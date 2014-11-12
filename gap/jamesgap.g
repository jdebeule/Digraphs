

# ismapped -> IsBound

#ismapped:=function(n,map) # checks is 'n' has an image under 'map'
#  local i;

#  for i in map do
#   if n=i[1] then
#      return true;
#    fi;
#  od;

#  return false;
#end;

# ForAll(map, IsBound)

#ismap:=function(map,degree) #checks if the map 'map' is a map
#local i,j,d;
#d:=degree;
#j:=true;
#for i in [1..d] do
#	if not ismapped(i,map) then
#		j:=false;
#	fi;
#od;
#
#return j;
#end;

#ImageListOfTransformation

#imagemap:=function(map)
#local i,j,l;
#l:=[];
#
#for i in map do
#	Add(l,i[2]);
#od;
#return AsSet(l);
#end;

# i^f

#mmapp:=function(n,map)
#local i,j,k;
#
#for i in map do
# if n=i[1] then
#  return i[2];  
# fi;
#od;
#return Print("Is not mapped","\n");
#end;



SearchForEndomorphisms:=function(map, condition, neighbours, result, limit)
  local nr, min, pos, i, j;
  
  if Length(result) = limit then 
    return;
  fi;
  #Print("at depth: ", Length(map), "\n");
  condition:=StructuralCopy(condition);
  nr := Length(condition[1]);

  for i in [1..Length(map)] do
    if IsBound(map[i]) then 
      for j in ListBlist([1..nr], neighbours[i]) do
        INTER_BLIST(condition[j], neighbours[map[i]]);
        if SIZE_BLIST(condition[j]) = 0 then 
          return;
        fi;
      od;
    fi;
  od;

  for i in [ 1 .. nr ] do
    if IsBound(map[i]) then
      condition[i]:=BlistList([1..nr], [map[i]]);
    fi;
  od;
  #Print(map,condition,"\n");
  if ForAll(condition, x-> SizeBlist(x) = 1) then 
    Add(result, Transformation(List(condition, x-> ListBlist([1..nr], x)[1])));
    return;
  fi;

  min := Length(neighbours) + 1;
  pos := 0;

  for i in [ 1 .. nr ] do 
    if (not IsBound(map[i])) and SizeBlist(condition[i]) < min then
      min := SizeBlist(condition[i]);
      pos := i;
    fi;
  od;
  map := ShallowCopy(map);
  for i in ListBlist([1..nr], condition[pos]) do
     map[pos] := i;
    SearchForEndomorphisms(map, condition, neighbours, result, limit);
  od;
  return;
end;

GraphEndomorphisms := function(digraph, limit)
  local result, nr, nbs;

  result := [];
  nr := DigraphNrVertices(digraph);
  nbs := List(OutNeighbours(digraph), x -> BlistList([ 1 .. nr ], x));
  SearchForEndomorphisms([], List([ 1 .. nr ], x -> BlistList([ 1 .. nr ], 
  [ 1 .. nr ])), nbs, result, limit);
  return result;
end;

endocandidate:=function(digraph,t)
  local o;
  o:=DigraphEdges(digraph);
  return IsSubset(o,OnSetsTuples(o,t));
end;



#startsearchhomallgivengraph:=function(graph,lss,map,conditionsonimage)
#local g,allorbs,orb,m,gr,f,l,k,i,j,kk,list,orbital,lls,condition;
##g:=group;
##list:=orbitlist;
##
#orbital:=MakeOrbitalfromGraph(graph);
#lls:=lss;#[1..DegreeAction(g)];
#orb:=orbital;
#m:=Adjacencymatrix(orb);;
#condition:=List([1..Size(m)],i->conditionsonimage);
##gr:=Graph(Group(()),[1..DegreeAction(g)],OnPoints, function(x,y) return m[x][y]=1; end, true);;
#f:=MakeListOfNeighboursForEachVertex(orb);
#
#return searchallhom(map,condition,f,orb,lls,[]);
#end;



