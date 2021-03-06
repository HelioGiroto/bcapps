(* Explore http://astronomy.stackexchange.com/questions/246/do-any-known-exoplanetary-solar-bodies-have-annular-eclipses-similar-to-earth?rq=1 *)

(* compute angular diameter from target diameter and distance *)

(* NOTE: for the distances/diameters we're dealing with this is
effectively ArcTan[diam/dist] but I'm being pedantic *)

ang[dist_,diam_] = 2*ArcTan[(diam/2)/dist]

(* the angular diameter of sun from planet p *)

angsun[p_] := ang[AstronomicalData[p, "SemimajorAxis"], 
 AstronomicalData["Sun", "Diameter"]];

(* angular diameter of satellite s as viewed from its planet p *)

(* could actually have combined this function w earlier one using
OrbitCenter, but nah *)

angmoon[s_, p_] := ang[AstronomicalData[s, "SemimajorAxis"], 
 AstronomicalData[s, "Diameter"]];

plans = Union[AstronomicalData["Planet"], {"Pluto"}]

t = Sort[Flatten[Table[{p, s, angmoon[s,p]/angsun[p]}, 
 {p, plans},
 {s, AstronomicalData[p, "Satellites"]}],1], #1[[3]] > #2[[3]] &]

(* doing both periapsis and apoapsis to get ranges *)

angsun2[p_] := {
ang[AstronomicalData[p, "Periapsis"],  AstronomicalData["Sun", "Diameter"]],
ang[AstronomicalData[p, "Apoapsis"],  AstronomicalData["Sun", "Diameter"]]
};

angmoon2[s_, p_] := {
ang[AstronomicalData[s, "Apoapsis"], AstronomicalData[s, "Diameter"]],
ang[AstronomicalData[s, "Periapsis"], AstronomicalData[s, "Diameter"]]
};

(* doing this as a module to catch Missing[NotAvailable] which messes
up Sort *)

angmoonsun[s_, p_] := Module[{data,t,b,mb,ms,sb,ss},
 t = Flatten[Table[data[x,y] = AstronomicalData[x,y], {x, {"Sun",p,s}},  
 {y, {"Periapsis","Apoapsis","Diameter"}}]];
 b = Length[Select[t, !NumericQ[#] &]];
 If[b>0,Return[{s,p,0,0}]];
 mb = ang[data[s,"Periapsis"], data[s,"Diameter"]];
 ms = ang[data[s,"Apoapsis"], data[s,"Diameter"]];
 sb = ang[data[p,"Periapsis"], data["Sun","Diameter"]];
 ss = ang[data[p,"Apoapsis"], data["Sun","Diameter"]];
 Return[{s,p, ms/sb, mb/ss}];
]

angplansun[s_, p_] := Module[{data,t,b,pb,ps,sb,ss},
 t = Flatten[Table[data[x,y] = AstronomicalData[x,y], {x, {"Sun",p,s}},  
 {y, {"Periapsis","Apoapsis","Diameter"}}]];
 b = Length[Select[t, !NumericQ[#] &]];
 If[b>0,Return[{s,p,0,0}]];
 pb = ang[data[s,"Periapsis"], data[p,"Diameter"]];
 ps = ang[data[s,"Apoapsis"], data[p,"Diameter"]];
 sb = ang[data[p,"Periapsis"]-data[s,"Apoapsis"], data["Sun","Diameter"]];
 ss = ang[data[p,"Apoapsis"]+data[s,"Apoapsis"], data["Sun","Diameter"]];
 Return[{s,p, ps/sb, pb/ss}];
]

(* below only works if s1 and s2 are satellites of the SAME planet *)

angsat2sun[p_, s1_, s2_] := Module[{data,t,b,ss1b,ss1s,ss,sb,mind,maxd},
 t = Flatten[Table[data[x,y] = AstronomicalData[x,y], {x, {"Sun",p,s1,s2}},
 {y, {"Periapsis","Apoapsis","Diameter"}}]];
 b = Length[Select[t, !NumericQ[#] &]];
 mind = Min[Abs[data[s1,"Periapsis"]-data[s2,"Apoapsis"]],
        Abs[data[s1,"Apoapsis"]-data[s2,"Periapsis"]]];
 maxd = Max[Abs[data[s1,"Periapsis"]-data[s2,"Apoapsis"]],
        Abs[data[s1,"Apoapsis"]-data[s2,"Periapsis"]]];
 If[b>0,Return[{s,p,0,0}]];
 s2b = ang[mind, data[s2,"Diameter"]];
 s2s = ang[maxd, data[s2,"Diameter"]];
 sb = ang[data[p,"Periapsis"]-data[s1,"Apoapsis"], data["Sun","Diameter"]];
 ss = ang[data[p,"Apoapsis"]+data[s1,"Apoapsis"], data["Sun","Diameter"]];
 Return[{s1,s2, s2s/sb, s2b/ss}];
]

plans2 = Union[AstronomicalData["Planet"], {"Pluto"}]

t2=Table[angmoonsun[s,p], {p, plans2}, {s, AstronomicalData[p, "Satellites"]}]

t3=Flatten[t2,1]

t4 = Sort[t3, #1[[3]] > #2[[3]] &];

t5=Table[angplansun[s,p], {p, plans2}, {s, AstronomicalData[p, "Satellites"]}]

t6 = Flatten[t5,1];

t7 = Sort[t6, #1[[3]] > #2[[3]] &];




t2 = Flatten[Table[{p, s, angmoon2[s,p]/angsun2[p]}, {p, plans2}, 
 {s, AstronomicalData[p, "Satellites"]}], 1]

t2 = Table[{p, s, angmoon2[s,p]/angsun2[p]}, {p, plans2}, 
 {s, AstronomicalData[p, "Satellites"]}]

t3 = Flatten[t2,1]

t4 = Sort[t3, #1[[3,1]] > #2[[3,1]] &]






