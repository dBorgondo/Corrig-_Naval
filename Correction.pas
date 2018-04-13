PROGRAM Bataille_Navale;

CONST
	MIN_LIGNE=1;
	MAX_LIGNE=10;
	MIN_colonne=1 ;
	MAX_colonne=10 ;
	NB_BATEAU=2;
	MAX_square=5;

	TYPE 
	square = record 
			ligne : Integer;
			colonne : Integer;
		End;

	 bateau = record
			nsquare : array [ 1..MAX_square ] of square;
		End;

	flotte = record
			nBateau : array [ 1..NB_BATEAU] of bateau
		End;

	bool = (VRAI,FAUX);

	position= (horizontal,vertical,diagonal);


	PROCEDURE createsquare (l,c : Integer ;VAR msquare : square);
		Begin 
			msquare.ligne:=l;
			msquare.colonne:=c;
		End;


	FUNCTION cmpsquare (msquare,tsquare : square) : BOOL;
		Begin
			If (msquare.ligne=tsquare.ligne) And (msquare.colonne=tsquare.colonne) Then
			Begin
				cmpsquare := VRAI;
			End
				Else
				Begin
					cmpsquare := FAUX ;
			End;
		End;


	FUNCTION createBateau (msquare : square; taille : Integer) : bateau;
		VAR
			res : bateau;
			pos : Integer;
			cpt : Integer;
			positionB : position;
		Begin
		randomize;
			pos := random(3);
			positionB := position(pos);
			for cpt:=1 to MAX_square do
			Begin 
				if (cpt<=taille) Then
				Begin
					res.nsquare[cpt].ligne := msquare.ligne;
					res.nsquare[cpt].colonne := msquare.colonne;
				End
					Else
					Begin 
						res.nsquare[cpt].ligne := 0;
						res.nsquare[cpt].ligne := 0;
					end;

				if (positionB=horizontal) Then 
				Begin
					msquare.colonne := msquare.colonne + 1; 
				End
					Else if (positionB=vertical) Then
						Begin
						msquare.ligne := msquare.ligne + 1;
						End
						Else if (positionB=diagonal) Then
						Begin
							msquare.ligne := msquare.ligne + 1;
							msquare.colonne := msquare.colonne + 1 ;
						end;
			end;
			createBateau := res;
		End;

	FUNCTION ctrl_square (mBat : bateau ; msquare : square) : BOOL;
		VAR
			val_test : BOOL;
			cpt : Integer;
		Begin
			val_test := FAUX;
			for cpt:=1 to MAX_square do
			Begin 
				If (cmpsquare(mBat.nsquare[cpt],msquare)= VRAI) Then
				Begin
					val_test := VRAI;
				End;
			End;
			ctrl_square:=val_test;
		End;

	FUNCTION ctrl_flotte (mFlotte: flotte ; msquare: square): BOOL;
		VAR
			cpt : Integer;
			res : BOOL;
		Begin
			res := FAUX;
			for cpt:=1 to NB_BATEAU do
			Begin
				If (ctrl_square(mFlotte.nBateau[cpt],msquare)=VRAI) Then
				Begin
					res := VRAI;
				End;
			End;
			ctrl_flotte := res;
		End;


	PROCEDURE flotte_joueur (VAR mFlotte : flotte; VAR goal : integer );
		VAR
			msquare :square;
			cpt,val_pos_ligne,val_pos_colonne,val_taille_bateau : Integer;
		Begin
			randomize;
			For cpt:=1 to NB_BATEAU do
			Begin
				val_pos_ligne :=(random(MAX_ligne-1)+1);
				val_pos_colonne :=(random(MAX_colonne-1)+1);
				val_taille_bateau :=random((MAX_square-1)+1);
				goal:=goal+val_taille_bateau;
				createsquare(val_pos_ligne,val_pos_colonne,msquare);
				mFlotte.nBateau[cpt] := createBateau(msquare,val_taille_bateau);
			End;
		end;

	function Allready_shooted (t_tir : square; shooted : array of square; shots : integer) : boolean;

	VAR
		counter : integer;

	Begin
		Allready_shooted:=false;
		counter:=1;
		if shots>0 then
		Begin
			while (counter<shots+1) and (Allready_shooted=false) do
				Begin
					if ((cmpsquare(shooted[counter],t_tir))=VRAI) Then Allready_shooted:=true else Allready_shooted:=false;
					counter:=counter+1;
				End;
		End
		else
			Begin
				Allready_shooted:=false;
			End;
	End;

	PROCEDURE tir (t_flotte:flotte;VAR score : integer;VAR shooted : array of square;VAR shots : integer);

	VAR
		ltir,ctir : integer;
		tir : square;

	Begin
		repeat
			writeln('Veuillez entrer la ligne de votre tir :');
			readln(ltir);
			writeln('Veuillez entrer la colonne de votre tir :');
			readln(ctir);
			createsquare(ltir,ctir,tir);
			if (Allready_shooted(tir,shooted,shots))then writeln('Vous avez deja tire ici, veuillez entrer de nouvelles coordonees:');
		until not(Allready_shooted(tir,shooted,shots));
		shots:=shots+1;
		shooted[shots]:=tir;
		if ((ctrl_flotte(t_flotte,tir))=VRAI) Then	
			Begin
				writeln('Touched');
				score:=score+1;
			End
			Else
			Begin
				writeln('Failed');
			End;
	End;


VAR
	shooted_j1, shooted_j2: array[1..400] of square;
	j1_score,j2_score,j1_shots, j2_shots,goal_j1,goal_j2 : integer;
	j1,j2 : flotte;
Begin
	J1_shots:=0;
	j2_shots:=0;
	j1_score:=0;
	j2_score:=0;
	goal_j1:=0;
	goal_J2:=0;
	flotte_joueur(j1,goal_J2);
	flotte_joueur(j2,goal_J1);
	readln;
	repeat 
	writeln('Tour du joueur 1');
	tir(j1,j1_score,shooted_J1,J1_shots);
	readln;
	if ((j1_score<goal_J1)) Then
		Begin
			writeln('Tour du joueur 2');
			tir(j2,j2_score,shooted_J2,J2_shots);
			readln;	
		End;
	until ((j1_score=goal_J1) or (j2_score=goal_j2));
End.