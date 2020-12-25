#define XTAL_FREQ 20000000
#include <pic.h>
#include "postteller.h"
#include <delay.h>
#define resetknop RA1
#define postknop RA0

const char getallen[10]={0b111111,0b110,0b1011011,0b1001111,0b1100110,0b1101101,0b1111101,0b111,0b1111111,0b1101111};
__CONFIG(0x3F0A);
static char aantal=0;
static char postenmag=10;
static char knipper=0;

void on_init( void )
{
  TRISA = 0x3F;
  TRISB = 0x00;
  OPTION = 0x00;
  INTCON = 0xC0;
  PIE1 = 0x01;
  PIR1 = 0x00;
  T1CON = 0x35;
  T2CON = 0x00;
  CCP1CON = 0x00;
  CMCON=0x07;
}

void on_timer1(void)
{
  if ((postenmag<10)&&(postknop)) postenmag++;
  
  if (aantal>0) {
    if (aantal<10) {
      if (knipper<3) {
        PORTB|=0x80;//puntje=1;
        knipper++;
      } else {
        PORTB&=0x7F;//puntje=0;
        if(knipper==6) {
          knipper=0;
        } else {
          knipper++;
        }
      }
    } else {
      if (knipper<2) {
        PORTB|=0x80;//puntje=1;
        knipper++;
      } else {
        PORTB&=0x7F;//puntje=0;
        if(knipper>=4) {
          knipper=0;
        } else {
          knipper++;
        }
      }
    }
  } else {
    PORTB&=0x7F;//puntje=0;
  }
  
}


void interrupt ISR( void )
{
  if ( TMR1IF )
  {
    TMR1IF=0;
    TMR1L=219;
    TMR1H=11;
    on_timer1();
  }
}

void main(void)
{
  on_init();
  PORTB=getallen[aantal];
  while(1)
  {
    if ((!postknop)&&(postenmag==10)) {
      aantal++;
      if (aantal<9) {
        PORTB=getallen[aantal];
      } else {
        PORTB=getallen[9];
      }
      postenmag=0;
    }
    if (resetknop){
      aantal=0;
      PORTB=getallen[aantal];
      postenmag=0;
    }
  }
}

