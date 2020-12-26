<?
error_reporting(E_ALL ^ E_NOTICE);
?>
<HTML>
<HEAD>
<?
if (!isset($_GET['print'])) 
{
  echo "<LINK REL=\"stylesheet\" HREF=\"../templates/rhuk_orange_smoothie/css/template_css.css.css\" TYPE=\"text/css\">";
}
?>

<TITLE>Cijfercalculator</TITLE>
</HEAD>
<BODY <? if (isset($_GET['print'])) 
{
echo "onLoad=\"javascript:window.print();\"";
}?>>
	<H2><B>Cijfercalculator</B></H2>

<?PHP

isset($_GET['print']) ? $print = $_GET['print'] : $print = 0;
isset($_GET['fpp']) ? $fpp = $_GET['fpp'] : $fpp = 0;
isset($_GET['min']) ? $min = $_GET['min'] : $min = 0;
isset($_GET['bonus']) ? $bonus = $_GET['bonus'] : $bonus = 0;
isset($_GET['minpunt']) ? $minpunt = $_GET['minpunt'] : $minpunt = 0;
isset($_GET['maxpunt']) ? $maxpunt = $_GET['maxpunt'] : $maxpunt = 0;
isset($_GET['mincijfer']) ? $mincijfer = $_GET['mincijfer'] : $mincijfer = 0;
isset($_GET['minprocent']) ? $minprocent = $_GET['minprocent'] : $minprocent = 0;
isset($_GET['submit']) ? $submit = $_GET['submit'] : $submit = '';


if ($fpp <= 0) $fpp = 3.0;
if ($min <= 0 || $min >= 10) $min = 1.0;
if ($bonus <= -1 || $bonus >= 10) $bonus = 0.0;

if ($minpunt <= 0) $minpunt = 55;
if ($maxpunt <= 0) $maxpunt = 100;
if ($mincijfer <= 0 || $mincijfer >= 10) $mincijfer = 5.5;
if ($minprocent <= 0 || $minprocent >= 100) $minprocent = 55;

if ($submit == "methode2")
{
	$minprocent = round(($minpunt / $maxpunt) * 100, 1);
}
if ($submit == "methode3")
{
	$minpunt = round($minprocent*0.01*$maxpunt, 1);
	$submit = "methode2";
}
if ($print==0) 
{
?>

<form action="cijfercalculator.php" method="get"> 
<input type="hidden" name="submit" value="<?=$submit?>">
<input type="hidden" name="minprocent" value="<?=$minprocent?>">
<input type="hidden" name="minpunt" value="<?=$minpunt?>">
<input type="hidden" name="maxpunt" value="<?=$maxpunt?>">
<input type="hidden" name="mincijfer" value="<?=$mincijfer?>">
<input type="hidden" name="fpp" value="<?=$fpp?>">
	  <TABLE class="navcontent">
	  <TR>
	  	<TD colspan="2" align="center"><B><I>Instellingen</I></B> </TD>
	  </TR>
	  <TR>
		<TD><B>Laagste cijfer</B>: </TD><TD><INPUT TYPE="text" NAME="min" size="4" value="<?=$min?>"></TD>
	  </TR>
	  <TR>
		<TD><B>Bonus</B>: </TD><TD><INPUT TYPE="text" NAME="bonus" size="4" value="<?=$bonus?>"></TD>
	  </TR>
	  <TR>
		<TD><INPUT TYPE="submit" value="Verander Instellingen"></TD>
	  </TR>
	  </table>
</form>
&nbsp;<P>
<B>Rekenwijze</B><P>

   
<TABLE class="navcontent">
<form action="cijfercalculator.php" method="get"> 
<input type="hidden" name="submit" value="methode3">
<INPUT TYPE="hidden" NAME="bonus" value="<?=$bonus?>">
<INPUT TYPE="hidden" NAME="min" value="<?=$min?>">
<TR>
<TD><INPUT TYPE="text" NAME="minprocent" size="4" value="<?=$minprocent?>"></TD>
<TD><B>% van de</B></TD>
<TD><INPUT TYPE="text" NAME="maxpunt" size="4" value="<?=$maxpunt?>"></TD>
<TD><B>is een</B></TD>
<TD><INPUT TYPE="text" NAME="mincijfer" size="4" value="<?=$mincijfer?>"></TD>
<TD><INPUT TYPE="submit" value="Genereer!"></TD>
</TR>
</form>


<tr><td align="center" colspan="6">

<B>OF</B>

</td></tr>

<TR>
<form action="cijfercalculator.php" method="get"> 
<input type="hidden" name="submit" value="methode2">
<INPUT TYPE="hidden" NAME="bonus" value="<?=$bonus?>">
<INPUT TYPE="hidden" NAME="min" value="<?=$min?>">
<TD><INPUT TYPE="text" NAME="minpunt" size="4" value="<?=$minpunt?>"></TD>
<TD><B>punten van de</B></TD>
<TD><INPUT TYPE="text" NAME="maxpunt" size="4" value="<?=$maxpunt?>"></TD>
<TD><B>is een</B></TD>
<TD><INPUT TYPE="text" NAME="mincijfer" size="4" value="<?=$mincijfer?>"></TD>
<TD><INPUT TYPE="submit" value="Genereer!"></TD>

</form>
</TR>

<tr><td align="center" colspan="6">

<B>OF</B>

</td></tr>

<TR>
<form action="cijfercalculator.php" method="get"> 
<input type="hidden" name="submit" value="methode1">
<INPUT TYPE="hidden" NAME="bonus" value="<?=$bonus?>">
<INPUT TYPE="hidden" NAME="min" value="<?=$min?>">
<TD><INPUT TYPE="text" NAME="fpp" size="4" value="<?=$fpp?>"></TD>
<TD colspan="4"><B>fouten per punt</B></TD>
<TD><INPUT TYPE="submit" value="Genereer!"></TD>
</TR>
</form>
</table>
&nbsp;<P>

<form action="cijfercalculator.php" method="get"> 
<INPUT TYPE="submit" value="Opnieuw Beginnen">
</form>

<BR>


<?
if ($print == 0 && $submit != "")
{
?>
<P>

<form action="cijfercalculator.php" method="get"> 
<input type="hidden" name="submit" value="<?=$submit?>">
<input type="hidden" name="bonus" value="<?=$bonus?>">
<input type="hidden" name="min" value="<?=$min?>">
<input type="hidden" name="minprocent" value="<?=$minprocent?>">
<input type="hidden" name="minpunt" value="<?=$minpunt?>">
<input type="hidden" name="maxpunt" value="<?=$maxpunt?>">
<input type="hidden" name="mincijfer" value="<?=$mincijfer?>">
<input type="hidden" name="fpp" value="<?=$fpp?>">
<input type="hidden" name="print" value="1">
<INPUT TYPE="submit" value="Afdrukken">
</form>
<? } ?>

<P>

<?PHP
}

if ($submit == "methode1" && $fpp > 0 && $min > 0 && $min < 10 && $bonus > -1 && $bonus < 10)
{ 

	
	echo '<B>Cijferlijst - '. $fpp . ' fouten per punt</B>
	<TABLE cellspacing="0" cellpadding="1" width="20%" class="navcontent">
	';

	echo '
	<TR>
		<TD align="right"><B>Fouten</B></TD>
		<TD>&nbsp;</TD>
		<TD align="left"><B>Cijfer&nbsp;&nbsp;&nbsp;</B></TD>
	</TR>
		';

	$temp = 0;

	while (round(10 - ($temp / $fpp) + $bonus,1) >= $min)
	{
		if (round($temp,0) != $temp)
		{
			$bgcolor = "#66CCFF";
		}
		else
		{
			$bgcolor = "";
		}
		echo '
		<TR>
			<TD bgcolor="'.$bgcolor.'" align="right">' . round($temp,1) .'</TD>
			<TD bgcolor="'.$bgcolor.'">&nbsp;</TD>
			<TD bgcolor="'.$bgcolor.'" align="left">' . round(10 - ($temp / $fpp) + $bonus, 1) .'</TD>
		</TR>
		';
		
		if (round(10 - ($temp / $fpp) + $bonus,1) == $min) $temp += 100;

		$temp += .5;
	}

} 
else if ($submit == "methode2" && $minpunt > 0 && $maxpunt > 0  && $bonus > -1 && $bonus < 10 && $mincijfer > 0 && $mincijfer < 10)
{ 
	$ding2=(10-$mincijfer)/($maxpunt-$minpunt);
	
	echo '<B>Cijferlijst - '. $minprocent . '% of '.$minpunt.' punten van de '.$maxpunt.' is een ' . $mincijfer . '</B>
	<TABLE cellspacing="0" cellpadding="1" width="20%" class="navcontent">
	';

	echo '
	<TR>
		<TD align="right"><B>Punten</B></TD>
		<TD>&nbsp;</TD>
		<TD align="left"><B>Cijfer&nbsp;&nbsp;&nbsp;</B></TD>
	</TR>
		';

	$newbonus = $bonus + 10 - ($maxpunt * $ding2);

	$temp = $maxpunt;

	while (round($temp * $ding2 + $newbonus,1) >= $min && $temp >= 0)
	{
		if ($yes == 1)
		{
			$bgcolor = "#66CCFF";
			$yes=0;
		}
		else
		{
			$bgcolor = "";
			$yes=1;
		}
		echo '
		<TR>
			<TD bgcolor="'.$bgcolor.'" align="right">' . round($temp,1) .'</TD>
			<TD bgcolor="'.$bgcolor.'">&nbsp;</TD>
			<TD bgcolor="'.$bgcolor.'" align="left">' . round($temp * $ding2 + $newbonus, 1) .'</TD>
		</TR>
		';
	
		if (round($temp * $ding2 + $newbonus,1) == $min) $temp -= 100;
		$temp -= 1;
	}

} 

?>

</table>


<P>Gemaakt door <A HREF="http://www.janpaulposma.nl" TARGET="_blank">Jan Paul Posma</A>, 2005, voor het <A HREF="http://www.wlg.nl" TARGET="_blank">Willem Lodewijk Gymnasium</A>.

  </BODY>
  </HTML>