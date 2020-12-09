#include <config.h>
#include <conio.h>
#include <unistd.h>
#include <dsensor.h>
#include <dmotor.h>
#include <dsound.h>
#include <dkey.h>

typedef enum _bool
{
    false=0,
    true=1
} bool;

typedef enum _afslag
{
    undefined=0,
    links=1,
    rechtdoor=2,
    rechts=3,
    bestemming=4
} afslag;

typedef struct
{
    signed char x;
    signed char y;
} vector;

typedef enum _robotstates
{
    zoeken=0,
    naardump_lijnen=1,
    naardump_naarmuur=2,
    naardump_langsmuur=3,
    dumpen=4,
    vandump_muur=5,
    vandump_lijnen=6
} robotstates;

// INPUT ...
#define LIGHTTOUCHSENS_1 SENSOR_2
#define LIGHTTOUCHSENS_2 SENSOR_3
#define LIGHTMAGAZIJN SENSOR_1
#define LIGHTTHRES_1 0x2E0
#define LIGHTTHRES_2 0x2E0
#define TOUCHTHRES_1 0x200
#define TOUCHTHRES_2 0x200
#define MAGAZIJNTHRES 0x1C0
// ... INPUT

// BESLISSER ...
#define MAXTOTAALBLOKJES 12
#define MAXBLOKJES 1
// ... BESLISSER

// TASK MANAGER ...
#define PID_MAX_TASKS 16
#define PID_STACK_SIZE (DEFAULT_STACK_SIZE*2)
// ... TASK MANAGER

// LIJNVOLGER ...
#define set_lijnvolger_adir(mydir) lijnvolger_adir=mydir
#define set_lijnvolger_cdir(mydir) lijnvolger_cdir=mydir
#define KRUISPUNT_WACHTTIJD 500
//#define KRUISPUNT_DRAAITIJD 500
#define KRUISPUNT_DRAAITIJD 800
#define KRUISPUNT_RECHTDOORTIJD 200
// ... LIJNVOLGER

// WALLHUGGER ...
#define set_wallhugger_adir(mydir) wallhugger_adir=mydir
#define set_wallhugger_cdir(mydir) wallhugger_cdir=mydir
#define HOEKPUNT_FAILSAFE 2500
#define HOEKPUNT_EINDDRAAI 180
#define UITHOEK_ACHTER 150
// ... WALLHUGGER

// ROUTEPLANNER ...
#define FIELD_WIDTH 10 //Begin bij 0 met tellen!
#define FIELD_HEIGHT 6
#define STARTPOINT_X 5
#define STARTPOINT_Y 0
// ... ROUTEPLANNER

// BESLISSER ...
#define LIJNDRIVESPEED ((MAX_SPEED/8)*7)
#define LIJNDRIVETURNSPEED ((MAX_SPEED/8)*8)
#define LIJNTURNSPEED ((MAX_SPEED/8)*7)
#define LIJNFOLLOWSPEED ((MAX_SPEED/8)*6)
#define WALLDRIVESPEED ((MAX_SPEED/8)*8)
#define WALLTURNSPEED ((MAX_SPEED/8)*8)
#define SLOWDUWSPEED ((MAX_SPEED/8)*4)
#define BLOKJESDELAY 200
#define BLOKJEDONKERDELAY 2000
#define TONGACHTERTIME 1600
// ... BESLISSER

// DUMPER ...
#define AANTAL_DUMPPLAATSEN 2
#define DUMPTIJD 2000
// ... DUMPER

// DUMPER ...
static const vector DumpPlaatsen[] =
{
{0,0} , {FIELD_WIDTH, 0}
};
static const vector DumpPlaatsenNext[] =
{
{-20,0} , {FIELD_WIDTH, -20}
};
static const vector RotationLeft[] =
{
{-1,0}, {0,-1}
};
static const vector RotationRight[] =
{
{0,-1}, {1,0}
};
static const bool TerugNaarRechts[] =
{
true, false
};
static const unsigned int WachttijdLinks[] =
{
1050, 950
};
static const unsigned int WachttijdRechts[] =
{
800, 1100
};

static unsigned int DumpTimer;
// ... DUMPER

// SOUND ...
static const note_t note1[] = {{40,1} , {PITCH_END,0}};
static const note_t note2[] = {{41,1} , {PITCH_END,0}};
static const note_t note3[] = {{42,1} , {PITCH_END,0}};
static const note_t note4[] = {{43,1} , {PITCH_END,0}};
static const note_t note5[] = {{44,1} , {PITCH_END,0}};
static const note_t note6[] = {{45,1} , {PITCH_END,0}};
static const note_t note7[] = {{46,1} , {PITCH_END,0}};
static const note_t note8[] = {{47,1} , {PITCH_END,0}};
static const note_t note9[] = {{48,1} , {PITCH_END,0}};

// LIJNVOLGER ...
static MotorDirection lijnvolger_adir, lijnvolger_cdir;
static bool lijnvolger_enabled;
static bool lijnvolger_kruispunt;
static afslag lijnvolger_afslag;
// ... LIJNVOLGER

// WALLHUGGER ...
static MotorDirection wallhugger_adir, wallhugger_cdir;
static bool wallhugger_enabled;
static bool wallhugger_hoekpunt;
static unsigned int HoekDraaiTimer, HoekEindDraaiTimer;
static bool wallhugger_terug;
static bool wallhugger_lijngehad;
static bool wallhugger_naarlinks;
static bool wallhugger_terugnaarrechts;
static bool wallhugger_wachttijd;
// ... WALLHUGGER


// ROUTEPLANNER ...
static vector myLocation;
static vector myRotation;
static vector myTarget;
// ... ROUTEPLANNER

// BESLISSER ...
static robotstates RobotState;
// ... BESLISSER

// TASK MANAGER ...
static tid_t pid[PID_MAX_TASKS];
static unsigned int pid_index;
// ... TASK MANAGER

// TASK MANAGER ...
void start_task(int (*code_start)(int, char**))
{
    if (pid_index < PID_MAX_TASKS - 1)
    {
      pid[pid_index++] = execi(code_start, 0, NULL, 0, PID_STACK_SIZE);
    }
}

int stop_tasks(int argc, char **argv0)
{
    int i;
    
    while(!shutdown_requested());
    for (i = 0; i < pid_index; i++) kill(pid[i]);
    
    return 0;
}

void inline init_pid(void)
{
    pid_index = 0;
}

void inline start_pid(void)
{
    execi(&stop_tasks, 0, NULL, 0, DEFAULT_STACK_SIZE);
    tm_start();
}
// ... TASK MANAGER

// LIJNVOLGER/WALLHUGGER ...
bool inline sensor_dark(unsigned int mySensorA, unsigned int myThresholdA)
{
  return ds_scale(mySensorA)>myThresholdA;
}

bool inline sensor_hit(unsigned int mySensorB, unsigned int myThresholdB)
{
  return (ds_scale(mySensorB)<myThresholdB);
}

int lijnvolger (int argc, char **argv)
{
    bool LightSens_1_Dark = false, LightSens_2_Dark = false;
    bool TouchSens_1 = false, TouchSens_2 = false;
    unsigned int LastKruispunt=KRUISPUNT_WACHTTIJD, DitKruispunt=KRUISPUNT_DRAAITIJD;
    lijnvolger_kruispunt = false;

    while(!shutdown_requested())
    {
      TouchSens_1 = sensor_hit(LIGHTTOUCHSENS_1, TOUCHTHRES_1);
      TouchSens_2 = sensor_hit(LIGHTTOUCHSENS_2, TOUCHTHRES_2);
      LightSens_1_Dark = sensor_dark(LIGHTTOUCHSENS_1, LIGHTTHRES_1);
      LightSens_2_Dark = sensor_dark(LIGHTTOUCHSENS_2, LIGHTTHRES_2);

      if (lijnvolger_enabled)
      {
        if (LastKruispunt > KRUISPUNT_WACHTTIJD + 100) LastKruispunt = KRUISPUNT_WACHTTIJD + 100;
        if (DitKruispunt > KRUISPUNT_DRAAITIJD + 100) DitKruispunt = KRUISPUNT_DRAAITIJD + 100;
        LastKruispunt++;
        DitKruispunt++;
        
        if (LightSens_1_Dark && LightSens_2_Dark && !lijnvolger_kruispunt)
        {
          if (LastKruispunt > KRUISPUNT_WACHTTIJD)
          {
            lijnvolger_kruispunt = true;
            DitKruispunt = 0;
            dsound_play(note1);
          }
        }
        else if ((!LightSens_2_Dark && lijnvolger_afslag == links) || (!LightSens_1_Dark && lijnvolger_afslag == rechts) || (lijnvolger_afslag == rechtdoor && (!LightSens_1_Dark || !LightSens_2_Dark)))
        {
          if(lijnvolger_kruispunt && ((lijnvolger_afslag == rechtdoor && DitKruispunt > KRUISPUNT_RECHTDOORTIJD) || DitKruispunt > KRUISPUNT_DRAAITIJD))
          {
            lijnvolger_afslag = undefined;
            dsound_play(note2);
            LastKruispunt = 0;
            lijnvolger_kruispunt = false;
          }
        }
        
        if (lijnvolger_kruispunt)
        {
          switch(lijnvolger_afslag)
          {
            case links:
              if (!LightSens_1_Dark)
                set_lijnvolger_adir(fwd);
              else
                set_lijnvolger_adir(rev);

              set_lijnvolger_cdir(fwd);
            break;
            case rechts:
              if (!LightSens_2_Dark)
                set_lijnvolger_cdir(fwd);
              else
                set_lijnvolger_cdir(rev);

              set_lijnvolger_adir(fwd);
            break;
            case rechtdoor:
              set_lijnvolger_adir(fwd);
              set_lijnvolger_cdir(fwd);
            break;
            case undefined:
            case bestemming:
            default:
              set_lijnvolger_adir(off);
              set_lijnvolger_cdir(off);
            break;
          }
        }
        else
        {
          if (!LightSens_1_Dark)
            set_lijnvolger_adir(fwd);
          else
            set_lijnvolger_adir(rev);

          if (!LightSens_2_Dark)
            set_lijnvolger_cdir(fwd);
          else
            set_lijnvolger_cdir(rev);
        }
      }
      
      if (wallhugger_enabled)
      {
        if (RobotState == vandump_lijnen)
        {
          if (!LightSens_1_Dark)
            set_wallhugger_adir(rev);
          else
            set_wallhugger_adir(off);

          if (!LightSens_2_Dark)
            set_wallhugger_cdir(rev);
          else
            set_wallhugger_cdir(off);
        }
        else if (RobotState == vandump_muur)
        {
          HoekDraaiTimer++;
          if (HoekDraaiTimer > UITHOEK_ACHTER)
          {
            if (LightSens_2_Dark) wallhugger_lijngehad = true;
            if (wallhugger_terugnaarrechts)
            {
              set_wallhugger_adir(fwd);
              set_wallhugger_cdir(rev);
            }
            else
            {
              set_wallhugger_adir(rev);
              set_wallhugger_cdir(fwd);
            }
          }
          else
          {
            set_wallhugger_adir(rev);
            set_wallhugger_cdir(rev);
          }
        }
        else
        {
          HoekDraaiTimer++;

            if (HoekDraaiTimer > wallhugger_wachttijd)
            {
              if (wallhugger_terug)
              {
                if (wallhugger_naarlinks)
                {
                  set_wallhugger_adir(rev);
                  set_wallhugger_cdir(brake);
                }
                else
                {
                  set_wallhugger_adir(brake);
                  set_wallhugger_cdir(rev);
                }
                HoekEindDraaiTimer++;
                if (HoekEindDraaiTimer > HOEKPUNT_EINDDRAAI) wallhugger_terug = false;
              }
              else if (!TouchSens_1 && !TouchSens_2)
              {
                set_wallhugger_adir(fwd);
                set_wallhugger_cdir(fwd);
              }
              else
              {
                if (wallhugger_naarlinks)
                {
                  if (TouchSens_1)
                    wallhugger_hoekpunt=true;

                  if (TouchSens_2)
                  {
                    wallhugger_terug=true;
                    HoekEindDraaiTimer=0;
                  }
                }
                else
                {
                  if (TouchSens_1)
                  {
                    wallhugger_terug=true;
                    HoekEindDraaiTimer=0;
                  }
                  
                  if (TouchSens_2)
                    wallhugger_hoekpunt=true;
                }
              }
            }
            else
            {
              if (wallhugger_naarlinks)
              {
                set_wallhugger_adir(brake);
                set_wallhugger_cdir(fwd);
              }
              else
              {
                set_wallhugger_adir(fwd);
                set_wallhugger_cdir(brake);
              }
            }

        }
      }
    }
    return 0;
}
// ... LIJNVOLGER/WALLHUGGER

// ROUTEPLANNER ...
vector inline VectorSom(vector a, vector b)
{
    vector ReturnValue;
    ReturnValue.x = a.x + b.x;
    ReturnValue.y = a.y + b.y;
    return ReturnValue;
}

unsigned int absint(signed int* a)
{
    signed int ReturnValue = a;
    if (ReturnValue < 0) ReturnValue = -ReturnValue;
    return (unsigned int) ReturnValue;
}

afslag VolgendeAfslag(vector TargetLocation)
{
    vector newLocation = VectorSom(myLocation, myRotation);
    signed int deltax_myLocation = (TargetLocation.x - myLocation.x);
    signed int deltay_myLocation = (TargetLocation.y - myLocation.y);
    signed int deltax_newLocation = (TargetLocation.x - newLocation.x);
    signed int deltay_newLocation = (TargetLocation.y - newLocation.y);

    if (deltax_myLocation == 0 && deltay_myLocation == 0) return bestemming;
    if (absint(deltax_newLocation) > absint(deltax_myLocation))
    {
      if (deltay_myLocation * -myRotation.x > 0)
      {
        return rechts;
      }
      else if (deltay_myLocation * -myRotation.x == 0)
      {
        if (myLocation.y == 0)
        {
          if (myRotation.x == -1)
            return rechts;
          else
            return links;
        }
        else if (myLocation.y == FIELD_HEIGHT)
        {
          if (myRotation.x == -1)
            return links;
          else
            return rechts;
        }
        else
        {
          return links;
        }
      }
      else
      {
        return links;
      }
    }
    else if (absint(deltay_newLocation) > absint(deltay_myLocation))
    {
      if (deltax_myLocation * myRotation.y > 0)
      {
        return rechts;
      }
      else if (deltax_myLocation * myRotation.y == 0)
      {
        if (myLocation.x == 0)
        {
          if (myRotation.y == 1)
            return rechts;
          else
            return links;
        }
        else if (myLocation.x == FIELD_WIDTH)
        {
          if (myRotation.y == 1)
            return links;
          else
            return rechts;
        }
        else
        {
          return links;
        }
      }
      else
      {
        return links;
      }
    }
    else
    {
      return rechtdoor;
    }
    return undefined;
}

afslag NeemAfslag(afslag myAfslag)
{
    vector NewRotation;
    if (myAfslag == undefined || myAfslag == bestemming) return myAfslag;
    switch (myAfslag)
    {
      case links:
        NewRotation.x = -myRotation.y;
        NewRotation.y = myRotation.x;
      break;
      case rechts:
        NewRotation.x = myRotation.y;
        NewRotation.y = -myRotation.x;
      break;
      case rechtdoor:
        NewRotation = myRotation;
      default:
      break;
    }
    myLocation = VectorSom(myLocation, NewRotation);
    myRotation = NewRotation;
    return myAfslag;
}

int routeplanner (int argc, char **argv)
{
    while(!shutdown_requested())
    {
      if (lijnvolger_afslag == undefined)
      {
        lijnvolger_afslag = NeemAfslag(VolgendeAfslag(myTarget));
      }
    }
}
// ... ROUTEPLANNER

// DUMPER ...
unsigned char VindDumpplaats()
{
    unsigned char i, BesteDumpplaats;
    unsigned int BesteAfstand=3000, DezeAfstand=0;
    
    for (i=0; i<AANTAL_DUMPPLAATSEN; i++)
    {
      DezeAfstand = absint(myLocation.x - DumpPlaatsen[i].x) + absint(myLocation.y - DumpPlaatsen[i].y);
      if (DezeAfstand < BesteAfstand)
      {
        BesteAfstand = DezeAfstand;
        BesteDumpplaats = i;
      }
    }
    return BesteDumpplaats;
}

bool inline IsHoekpunt()
{
    unsigned char i;

    for (i=0; i<AANTAL_DUMPPLAATSEN; i++)
    {
      if (DumpPlaatsen[i].x == myLocation.x && DumpPlaatsen[i].y == myLocation.y) return true;
    }
    return false;
}

bool inline CheckHoekNaarLinks(unsigned char myHoekpunt)
{
  return (myRotation.x == RotationLeft[myHoekpunt].x && myRotation.y == RotationLeft[myHoekpunt].y);
}
// ... DUMPER

// BESLISSER ...
bool inline BlokjeDetected()
{
    return sensor_dark(LIGHTMAGAZIJN, MAGAZIJNTHRES);
}

int beslisser (int argc, char **argv)
{
    bool ChangeY = false, DumperTerug = false;
    unsigned int BlokjesTimer = 0, BlokjeDonkerTimer = 0, TongAchterTimer = 0;
    vector ZoekTarget = {0,0};
    unsigned char Dumpplaats, AantalBlokjes = 0, TotaalBlokjes = 0;


    motor_a_speed(LIJNDRIVESPEED);
    motor_c_speed(LIJNDRIVESPEED);

    while (!shutdown_requested())
    {
      switch (RobotState)
      {
        case zoeken:
        case naardump_lijnen:
        case naardump_naarmuur:
          lijnvolger_enabled = true;
          wallhugger_enabled = false;
          
          if (TongAchterTimer < TONGACHTERTIME)
          {
            TongAchterTimer++;
            motor_b_dir(fwd);
          }
          else if (TongAchterTimer == TONGACHTERTIME)
          {
            TongAchterTimer++;
            motor_b_dir(off);
          }
          else
          {
            motor_b_dir(off);
          }

          if (lijnvolger_adir == rev)
          {
            if (lijnvolger_kruispunt)
            {
              motor_a_speed(LIJNTURNSPEED);
            }
            else
            {
              motor_a_speed(LIJNFOLLOWSPEED);
            }
          }
          else
          {
            if (lijnvolger_kruispunt && lijnvolger_afslag != rechtdoor)
            {
              motor_a_speed(LIJNDRIVETURNSPEED);
            }
            else
            {
              motor_a_speed(LIJNDRIVESPEED);
            }
          }

          if (lijnvolger_adir == fwd)
          {
            motor_a_dir(rev);
          }
          else if (lijnvolger_adir == rev)
          {
            motor_a_dir(fwd);
          }
          else
          {
            motor_a_dir(lijnvolger_adir);
          }
            
          if (lijnvolger_cdir == rev)
          {
            if (lijnvolger_kruispunt)
            {
              motor_c_speed(LIJNTURNSPEED);
            }
            else
            {
              motor_c_speed(LIJNFOLLOWSPEED);
            }
          }
          else
          {
            if (lijnvolger_kruispunt && lijnvolger_afslag != rechtdoor)
            {
              motor_c_speed(LIJNDRIVETURNSPEED);
            }
            else
            {
              motor_c_speed(LIJNDRIVESPEED);
            }
          }

          if (lijnvolger_cdir == fwd)
          {
            motor_c_dir(rev);
          }
          else if (lijnvolger_cdir == rev)
          {
            motor_c_dir(fwd);
          }
          else
          {
            motor_c_dir(lijnvolger_cdir);
          }
        break;
        case naardump_langsmuur:
        case vandump_muur:
        case vandump_lijnen:
          lijnvolger_enabled = false;
          wallhugger_enabled = true;
          
          motor_b_dir(off);

          if (wallhugger_adir == rev)
            motor_a_speed(WALLDRIVESPEED);
          else
            motor_a_speed(WALLTURNSPEED);

          if (wallhugger_adir == fwd)
          {
            motor_a_dir(rev);
          }
          else if (wallhugger_adir == rev)
          {
            motor_a_dir(fwd);
          }
          else
          {
            motor_a_dir(wallhugger_adir);
          }

          if (wallhugger_cdir == rev)
            motor_c_speed(WALLDRIVESPEED);
          else
            motor_c_speed(WALLTURNSPEED);

          if (wallhugger_cdir == fwd)
          {
            motor_c_dir(rev);
          }
          else if (wallhugger_cdir == rev)
          {
            motor_c_dir(fwd);
          }
          else
          {
            motor_c_dir(wallhugger_cdir);
          }
        break;
        case dumpen:
          lijnvolger_enabled = false;
          wallhugger_enabled = false;

          if (DumperTerug || (DumpTimer > (DUMPTIJD/8)*6 && DumpTimer < (DUMPTIJD/8)*7))
            motor_b_dir(fwd);
          else
            motor_b_dir(rev);
          motor_b_speed(MAX_SPEED);
          
          motor_a_speed(SLOWDUWSPEED);
          motor_c_speed(SLOWDUWSPEED);
          
          if (DumpTimer++ > DUMPTIJD)
          {
            if (!DumperTerug)
            {
              DumperTerug = true;
              DumpTimer = 0;
            }
          }
          if (DumpTimer > (DUMPTIJD/8)*5)
          {
            if (DumpTimer > (DUMPTIJD/8)*6 && DumpTimer < (DUMPTIJD/8)*7)
            {
              if (wallhugger_naarlinks)
              {
                motor_a_dir(brake);
                motor_c_dir(rev);
              }
              else
              {
                motor_a_dir(rev);
                motor_c_dir(brake);
              }
            }
            else
            {
              motor_a_dir(rev);
              motor_c_dir(rev);
            }
          }
          else
          {
            motor_a_dir(off);
            motor_c_dir(off);
          }
        break;
        default:
          lijnvolger_enabled = false;
          wallhugger_enabled = false;
          motor_a_dir(off);
          motor_b_dir(off);
          motor_c_dir(off);
        break;
      }
      switch (RobotState)
      {
        case zoeken:
          if (lijnvolger_afslag == bestemming)
          {
            if (ChangeY)
            {
              ChangeY = false;
              if (ZoekTarget.y < FIELD_HEIGHT)
                ZoekTarget.y++;
            }
            else
            {
              ChangeY = true;
              if (ZoekTarget.x == 0)
              {
                if (ZoekTarget.y == 0)
                {
                  ChangeY = false;
                  ZoekTarget.x = 1;
                }
                else
                  ZoekTarget.x = FIELD_WIDTH;
              }
              else if (ZoekTarget.x == 1)
                ZoekTarget.x = FIELD_WIDTH;
              else
                ZoekTarget.x = 0;
            }
            //if (AantalBlokjes >= MAXBLOKJES || TotaalBlokjes >= MAXTOTAALBLOKJES || BlokjeDetected())
            if (AantalBlokjes >= MAXBLOKJES || BlokjeDetected() || (myLocation.x == FIELD_WIDTH && myLocation.y == FIELD_HEIGHT))
            {
              Dumpplaats = VindDumpplaats();
              myTarget = DumpPlaatsen[Dumpplaats];
              lijnvolger_afslag = undefined;
              RobotState = naardump_lijnen;
              dsound_play(note3);
            }
            else
            {
              myTarget = ZoekTarget;
              lijnvolger_afslag = undefined;
            }
          }
          
          if (BlokjeDetected())
          {
            if (BlokjesTimer > BLOKJESDELAY)
            {
              AantalBlokjes++;
              TotaalBlokjes++;
              BlokjesTimer = 0;
              dsound_play(note8);
            }
            BlokjeDonkerTimer++;
          }
          else
          {
            BlokjeDonkerTimer = 0;
            BlokjesTimer++;
          }
          if (sensor_hit(LIGHTTOUCHSENS_1, TOUCHTHRES_1) && sensor_hit(LIGHTTOUCHSENS_2, TOUCHTHRES_2))
          {
            myLocation = DumpPlaatsen[Dumpplaats];
            myRotation = RotationLeft[Dumpplaats];
            RobotState = vandump_lijnen;
          }
          cputw(lijnvolger_kruispunt * 0x1000 + lijnvolger_afslag * 0x100 + sensor_dark(LIGHTTOUCHSENS_1, LIGHTTHRES_1) * 0x10 + sensor_dark(LIGHTTOUCHSENS_2, LIGHTTHRES_2));
          //cputw(ds_scale(LIGHTTOUCHSENS_1));
          break;
        case naardump_lijnen:
          if (lijnvolger_afslag == bestemming && IsHoekpunt() && lijnvolger_kruispunt)
          {
            myTarget = DumpPlaatsenNext[Dumpplaats];
            lijnvolger_afslag = undefined;
            RobotState = naardump_naarmuur;
            wallhugger_naarlinks = CheckHoekNaarLinks(Dumpplaats);
            wallhugger_terugnaarrechts = TerugNaarRechts[Dumpplaats] && ZoekTarget.y != 0;
            if (wallhugger_naarlinks)
              wallhugger_wachttijd = WachttijdLinks[Dumpplaats];
            else
              wallhugger_wachttijd = WachttijdRechts[Dumpplaats];
          }
          cputs("NDMP1");
        break;
        case naardump_naarmuur:
          if (true || sensor_hit(LIGHTTOUCHSENS_1, TOUCHTHRES_1) || sensor_hit(LIGHTTOUCHSENS_2, TOUCHTHRES_2))
          {
            wallhugger_hoekpunt = false;
            wallhugger_terug = false;
            HoekDraaiTimer = 0;
            HoekEindDraaiTimer = 0;
            RobotState = naardump_langsmuur;
          }
          cputs("NDMP2");
        break;
        case naardump_langsmuur:
          if (wallhugger_hoekpunt)
          {
            DumpTimer = 0;
            DumperTerug = false;
            RobotState = dumpen;
          }
          cputs("NDMP3");
          //cputw(sensor_hit(LIGHTTOUCHSENS_1, TOUCHTHRES_1)*0x10 + sensor_hit(LIGHTTOUCHSENS_2, TOUCHTHRES_2));
        break;
        case dumpen:
          if (DumpTimer > DUMPTIJD)
          {
            if (DumperTerug)
            {
              HoekDraaiTimer = 0;
              wallhugger_lijngehad = false;
              RobotState = vandump_muur;
            }
          }
          AantalBlokjes = 0;
          cputs("DUMP");
        break;
        case vandump_muur:
          if (wallhugger_lijngehad && !sensor_dark(LIGHTTOUCHSENS_2, LIGHTTHRES_2))
          //if (wallhugger_lijngehad && !sensor_dark(LIGHTTOUCHSENS_1, LIGHTTHRES_1) && !sensor_dark(LIGHTTOUCHSENS_2, LIGHTTHRES_2))
          {
            RobotState = vandump_lijnen;
          }
          cputs("VDMP1");
        break;
        case vandump_lijnen:
          if (sensor_dark(LIGHTTOUCHSENS_1, LIGHTTHRES_1) && ((sensor_dark(LIGHTTOUCHSENS_2, LIGHTTHRES_2) && wallhugger_terugnaarrechts) || (sensor_dark(LIGHTTOUCHSENS_1, LIGHTTHRES_1) && !wallhugger_terugnaarrechts)))
          { // Klopt de regel hierboven??!??!?!?!
            myLocation = DumpPlaatsen[Dumpplaats];
            if (TerugNaarRechts[Dumpplaats] && ZoekTarget.y != 0)
              myRotation = RotationLeft[Dumpplaats];
            else
              myRotation = RotationRight[Dumpplaats];
            myTarget = ZoekTarget;
            lijnvolger_afslag = undefined;
            RobotState = zoeken;
          }
          cputs("VDMP2");
        break;
        default:
          cputs("NEE");
        break;
      }
    }
    return 0;
}
// ... BESLISSER

void initme (void)
{
    ds_active(&LIGHTTOUCHSENS_1);
    ds_active(&LIGHTTOUCHSENS_2);

    myLocation.x = STARTPOINT_X;
    myLocation.y = STARTPOINT_Y;
    myRotation.x = 0;
    myRotation.y = 1;

    myTarget.x = 0;
    myTarget.y = 0;
}

int main (int argc, char **argv)
{
    initme();
    init_pid();
    start_task(&lijnvolger);
    start_task(&routeplanner);
    start_task(&beslisser);
    start_pid();
    return 0;
}
