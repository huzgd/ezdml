(*******************************************************************************
                                 L I C E N S E
********************************************************************************

BESEN - A ECMAScript Fifth Edition Object Pascal Implementation
Copyright (C) 2009-2016, Benjamin 'BeRo' Rosseaux

The source code of the BESEN ecmascript engine library and helper tools are 
distributed under the Library GNU Lesser General Public License Version 2.1 
(see the file copying.txt) with the following modification:

As a special exception, the copyright holders of this library give you
permission to link this library with independent modules to produce an
executable, regardless of the license terms of these independent modules,
and to copy and distribute the resulting executable under terms of your choice,
provided that you also meet, for each linked independent module, the terms
and conditions of the license of that module. An independent module is a module
which is not derived from or based on this library. If you modify this
library, you may extend this exception to your version of the library, but you 
are not obligated to do so. If you do not wish to do so, delete this exception
statement from your version.

If you didn't receive a copy of the license, see <http://www.gnu.org/licenses/>
or contact:
      Free Software Foundation
      675 Mass Ave
      Cambridge, MA  02139
      USA

*******************************************************************************)
unit BESENSelfBalancedTree;
{$i BESEN.inc}

interface

uses BESENConstants,BESENTypes,BESENStringUtils;

type PBESENSelfBalancedTreeValue=^TBESENSelfBalancedTreeValue;
     TBESENSelfBalancedTreeValue=record
      case boolean of
       false:(i:int64);
       true:(p:pointer);
     end;

     PBESENSelfBalancedTreeNode=^TBESENSelfBalancedTreeNode;
     TBESENSelfBalancedTreeNode=record
      Parent,Left,Right,PreviousKey,NextKey:PBESENSelfBalancedTreeNode;
      Level:int64;
      Key:TBESENString;
      Value:TBESENSelfBalancedTreeValue;
     end;

     TBESENSelfBalancedTreeKeys=array of widestring;

     TBESENSelfBalancedTree=class
      protected
       procedure Skew(OldParent:PBESENSelfBalancedTreeNode);
       function Split(OldParent:PBESENSelfBalancedTreeNode):boolean;
       procedure RebalanceAfterLeafAdd(n:PBESENSelfBalancedTreeNode);
       procedure DeleteNode(n:PBESENSelfBalancedTreeNode);
       function First(StartNode:PBESENSelfBalancedTreeNode):PBESENSelfBalancedTreeNode;
       function Next(n:PBESENSelfBalancedTreeNode):PBESENSelfBalancedTreeNode;
       function FindNode(const Key:TBESENString):PBESENSelfBalancedTreeNode;
       procedure ClearNode(var Node:PBESENSelfBalancedTreeNode);
       procedure OptimizeNode(var Node:PBESENSelfBalancedTreeNode;MoreOptimize:boolean);
       function GetValue(Key:TBESENString):TBESENSelfBalancedTreeValue;
       procedure SetValue(Key:TBESENString;Value:TBESENSelfBalancedTreeValue);
      public
       RootNode:PBESENSelfBalancedTreeNode;
       FirstKey,LastKey:PBESENSelfBalancedTreeNode;
       constructor Create;
       destructor Destroy; override;
       function Find(const Key:TBESENString;var Value:TBESENSelfBalancedTreeValue):boolean;
       function FindNearest(const Key:TBESENString):PBESENSelfBalancedTreeNode;
       function Insert(const Key:TBESENString;Value:TBESENSelfBalancedTreeValue):PBESENSelfBalancedTreeNode;
       procedure Remove(const Key:TBESENString);
       procedure Optimize;
       function Keys:TBESENSelfBalancedTreeKeys;
       property Values[Key:TBESENString]:TBESENSelfBalancedTreeValue read GetValue write SetValue; default;
     end;

implementation

constructor TBESENSelfBalancedTree.Create;
begin
 inherited Create;
 new(RootNode);
 fillchar(RootNode^,sizeof(TBESENSelfBalancedTreeNode),#0);
 RootNode^.Level:=$7fffffffffffffff;
 FirstKey:=nil;
 LastKey:=nil;
end;

destructor TBESENSelfBalancedTree.Destroy;
begin
 ClearNode(RootNode^.Left);
 dispose(RootNode);
 inherited Destroy;
end;

function TBESENSelfBalancedTree.First(StartNode:PBESENSelfBalancedTreeNode):PBESENSelfBalancedTreeNode;
begin
 try
  if not assigned(StartNode^.Left) then begin
   result:=nil;
   exit;
  end;
  result:=StartNode;
  while assigned(result^.Left) do begin
   result:=result^.Left;
  end;
 except
  result:=nil;
 end;
end;

function TBESENSelfBalancedTree.Next(n:PBESENSelfBalancedTreeNode):PBESENSelfBalancedTreeNode;
begin
 try
  if assigned(n^.Right) then begin
   result:=n^.Right;
   while assigned(result^.Left) do begin
    result:=result^.Left;
   end;
  end else begin
   while assigned(n^.Parent) and (n^.Parent^.Right=n) do begin
    n:=n^.Parent;
   end;
   n:=n^.Parent;
   if not assigned(n) then begin
    result:=nil;
    exit;
   end;
   result:=n;
  end;
 except
  result:=nil;
 end;
end;

procedure TBESENSelfBalancedTree.Skew(OldParent:PBESENSelfBalancedTreeNode);
var NewParent:PBESENSelfBalancedTreeNode;
begin
{$ifdef UseAssert}
 Assert(assigned(OldParent));
{$endif}
 NewParent:=OldParent^.Left;
{$ifdef UseAssert}
 Assert(assigned(NewParent));
{$endif}
 if OldParent^.Parent^.Left=OldParent then begin
  OldParent^.Parent^.Left:=NewParent;
 end else begin
  OldParent^.Parent^.Right:=NewParent;
 end;
 NewParent^.Parent:=OldParent^.Parent;
 OldParent^.Parent:=NewParent;

 OldParent^.Left:=NewParent^.Right;
 if assigned(OldParent^.Left) then begin
  OldParent^.Left^.Parent:=OldParent;
 end;
 NewParent^.Right:=OldParent;

 if assigned(OldParent^.Left) then begin
  OldParent^.level:=OldParent^.Left^.level+1;
 end else begin
  OldParent^.level:=1;
 end;
end;

function TBESENSelfBalancedTree.Split(OldParent:PBESENSelfBalancedTreeNode):boolean;
var NewParent:PBESENSelfBalancedTreeNode;
begin
{$ifdef UseAssert}
 Assert(assigned(OldParent));
{$endif}
 NewParent:=OldParent^.Right;
 if assigned(NewParent) and assigned(NewParent^.Right) and (NewParent^.Right^.level=OldParent^.Level) then begin
  if OldParent^.Parent^.Left=OldParent then begin
   OldParent^.Parent^.Left:=NewParent;
  end else begin
   OldParent^.Parent^.Right:=NewParent;
  end;
  NewParent^.Parent:=OldParent^.Parent;
  OldParent^.Parent:=NewParent;

  OldParent^.Right:=NewParent^.Left;
  if assigned(OldParent^.Right) then begin
   OldParent^.Right^.Parent:=OldParent;
  end;
  NewParent^.Left:=OldParent;

  NewParent^.level:=OldParent^.level+1;

  result:=true;
 end else begin
  result:=false;
 end;
end;

procedure TBESENSelfBalancedTree.RebalanceAfterLeafAdd(n:PBESENSelfBalancedTreeNode);
begin
 // n is a node that has just been inserted and is now a Leaf node.
 n^.Level:=1;
 n^.Left:=nil;
 n^.Right:=nil;
 n:=n^.Parent;
 while n<>RootNode do begin
  if (assigned(n^.Left) and (n^.Level<>(n^.Left^.Level+1))) or ((not assigned(n^.Left)) and (n^.Level<>1)) then begin
   // this point the tree is correct, except (AA2) for n->Parent
   Skew(n);
   // We handle it (a Left add) by changing it into a Right add using Skew
   // If the original add was to the Left side of a node that is on the
   // Right side of a horizontal link, n now points to the rights side
   // of the second horizontal link, which is correct.
   // However if the original add was to the Left of node with a horizontal
   // link, we must get to the Right side of the second link.
   if (not assigned(n^.Right)) or (n^.Level<>n^.Right^.Level) then begin
    n:=n^.Parent;
   end;
  end;
  if not Split(n^.Parent) then begin
   break;
  end;
  n:=n^.Parent;
 end;
end;

function TBESENSelfBalancedTree.FindNode(const Key:TBESENString):PBESENSelfBalancedTreeNode;
var n:PBESENSelfBalancedTreeNode;
begin
 try
  result:=nil;
  n:=RootNode^.Left;
  while assigned(n) do begin
   case BESENStringCompare(Key,n^.Key) of
    -1:begin
     n:=n^.Left;
    end;
    1:begin
     n:=n^.Right;
    end;
    else begin
     result:=n;
     break;
    end;
   end;
  end;
 except
  result:=nil;
 end;
end;

function TBESENSelfBalancedTree.FindNearest(const Key:TBESENString):PBESENSelfBalancedTreeNode;
var n:PBESENSelfBalancedTreeNode;
begin
 try
  result:=nil;
  n:=RootNode^.Left;
  while assigned(n) do begin
   result:=n;
   case BESENStringCompare(Key,n^.Key) of
    -1:begin
     n:=n^.Left;
    end;
    1:begin
     n:=n^.Right;
    end;
    else begin
     break;
    end;
   end;
  end;
 except
  result:=nil;
 end;
end;

function TBESENSelfBalancedTree.Insert(const Key:TBESENString;Value:TBESENSelfBalancedTreeValue):PBESENSelfBalancedTreeNode;
var n,s:PBESENSelfBalancedTreeNode;
    LessThan:boolean;
begin
 result:=nil;
 try
  n:=nil;
  s:=RootNode^.Left;
  while assigned(s) do begin
   case BESENStringCompare(Key,s^.Key) of
    -1:begin
     s:=s^.Left;
    end;
    1:begin
     s:=s^.Right;
    end;
    else begin
     n:=s;
     break;
    end;
   end;
  end;
  if assigned(s) then begin
   n^.Value:=Value;
  end else begin
   new(n);
   fillchar(n^,sizeof(TBESENSelfBalancedTreeNode),#0);
   n^.Key:=Key;
   n^.Value:=Value;
   if assigned(LastKey) then begin
    n^.PreviousKey:=LastKey;
    LastKey^.NextKey:=n;
    LastKey:=n;
   end else begin
    FirstKey:=n;
    LastKey:=n;
   end;
   s:=RootNode;
   LessThan:=true;
   while (LessThan and assigned(s^.Left)) or ((not LessThan) and assigned(s^.Right)) do begin
    if LessThan then begin
     s:=s^.Left;
    end else begin
     s:=s^.Right;
    end;
    LessThan:=Key<s^.Key;
   end;
   if LessThan then begin
    s^.Left:=n;
   end else begin
    s^.Right:=n;
   end;
   n^.Parent:=s;
   RebalanceAfterLeafAdd(n);
   result:=n;
  end;
 except
  result:=nil;
 end;
end;

procedure TBESENSelfBalancedTree.DeleteNode(n:PBESENSelfBalancedTreeNode);
var Leaf,Temp:PBESENSelfBalancedTreeNode;
begin
 try
  // If n is not a Leaf, we first swap it out with the Leaf node that just
  // precedes it.
  Leaf:=n;
  if assigned(n^.Left) then begin
   Leaf:=n^.Left;
   while assigned(Leaf^.Right) do begin
    Leaf:=Leaf^.Right;
   end;
  end else if assigned(n^.Right) then begin
   Leaf:=n^.Right;
  end;

  if Leaf^.Parent=n then begin
   Temp:=Leaf;
  end else begin
   Temp:=Leaf^.Parent;
  end;
  if Leaf^.Parent^.Left=Leaf then begin
   Leaf^.Parent^.Left:=nil;
  end else begin
   Leaf^.Parent^.Right:=nil;
  end;

  if n<>Leaf then begin
   if n^.Parent^.Left=n then begin
    n^.Parent^.Left:=Leaf;
   end else begin
    n^.Parent^.Right:=Leaf;
   end;
   Leaf^.Parent:=n^.Parent;
   if assigned(n^.Left) then begin
    n^.Left^.Parent:=Leaf;
   end;
   Leaf^.Left:=n^.Left;
   if assigned(n^.Right) then begin
    n^.Right^.Parent:=Leaf;
   end;
   Leaf^.Right:=n^.Right;
   Leaf^.level:=n^.level;
  end;
  if n<>RootNode then begin
   n^.Key:='';
   if assigned(n^.PreviousKey) then begin
    n^.PreviousKey^.NextKey:=n^.NextKey;
   end else if FirstKey=n then begin
    FirstKey:=n^.NextKey;
   end;
   if assigned(n^.NextKey) then begin
    n^.NextKey^.PreviousKey:=n^.PreviousKey;
   end else if LastKey=n then begin
    LastKey:=n^.PreviousKey;
   end;
   dispose(n);
  end;

  while Temp<>RootNode do begin
   if (assigned(Temp^.Left) and (Temp^.level>(Temp^.Left^.level+1))) or ((not assigned(Temp^.Left)) and (Temp^.level>1)) then begin
    dec(Temp^.level);
    if Split(Temp) then begin
     if Split(Temp) then begin
      Skew(Temp^.Parent^.Parent);
     end;
     break;
    end;
    Temp:=Temp^.Parent;
   end else if (assigned(Temp^.Right) and (Temp^.level<=(Temp^.Right^.level+1))) or ((not assigned(Temp^.Right)) and (Temp^.level<=1)) then begin
    break;
   end else begin
    Skew(Temp);
 {  if assigned(Temp^.Right) then begin
     if assigned(Temp^.Right^.Left) then begin
      Temp^.Right^.level:=Temp^.Right^.level+1;
     end else begin
      Temp^.Right^.level:=1;
     end;
    end;}
    if Temp^.level>Temp^.Parent^.level then begin
     Skew(Temp);
     Split(Temp^.Parent^.Parent);
     break;
    end;
    Temp:=Temp^.Parent^.Parent;
   end;
  end;
 except
 end;
end;

procedure TBESENSelfBalancedTree.Remove(const Key:TBESENString);
var n:PBESENSelfBalancedTreeNode;
begin
 try
  n:=RootNode^.Left;
  while assigned(n) do begin
   case BESENStringCompare(Key,n^.Key) of
    -1:begin
     n:=n^.Left;
    end;
    1:begin
     n:=n^.Right;
    end;
    else begin
     DeleteNode(n);
     break;
    end;
   end;
  end;
 except
 end;
end;

procedure TBESENSelfBalancedTree.ClearNode(var Node:PBESENSelfBalancedTreeNode);
begin
 if not assigned(Node) then begin
  exit;
 end;
 Node^.Key:='';
 if assigned(Node^.PreviousKey) then begin
  Node^.PreviousKey^.NextKey:=Node^.NextKey;
 end else if FirstKey=Node then begin
  FirstKey:=Node^.NextKey;
 end;
 if assigned(Node^.NextKey) then begin
  Node^.NextKey^.PreviousKey:=Node^.PreviousKey;
 end else if LastKey=Node then begin
  LastKey:=Node^.PreviousKey;
 end;
 ClearNode(Node^.Left);
 ClearNode(Node^.Right);
 dispose(Node);
 Node:=nil;
end;

procedure TBESENSelfBalancedTree.OptimizeNode(var Node:PBESENSelfBalancedTreeNode;MoreOptimize:boolean);
var Nodes:array of TBESENSelfBalancedTreeNode;

    NodeCount,NodeIndex:integer;
 procedure CountNodes(Node:PBESENSelfBalancedTreeNode);
 begin
  if not assigned(Node) then begin
   exit;
  end;
  CountNodes(Node^.Left);
  CountNodes(Node^.Right);
  inc(NodeCount);
 end;
 procedure CollectNodes(Node:PBESENSelfBalancedTreeNode);
 begin
  if not assigned(Node) then begin
   exit;
  end;
  CollectNodes(Node^.Left);
  if NodeIndex>=length(Nodes) then begin
   NodeCount:=NodeIndex+1;
   SetLength(Nodes,NodeCount);
  end;
  Nodes[NodeIndex].Key:=Node^.Key;
  Nodes[NodeIndex].Value:=Node^.Value;
  Node^.Key:='';
  inc(NodeIndex);
  CollectNodes(Node^.Right);
 end;
 procedure FreeNodes(var Node:PBESENSelfBalancedTreeNode);
 begin
  if not assigned(Node) then begin
   exit;
  end;
  Node^.Key:='';
  if assigned(Node^.PreviousKey) then begin
   Node^.PreviousKey^.NextKey:=Node^.NextKey;
  end;
  if assigned(Node^.NextKey) then begin
   Node^.NextKey^.PreviousKey:=Node^.PreviousKey;
  end;
  if FirstKey=Node then begin
   FirstKey:=Node^.NextKey;
  end;
  if LastKey=Node then begin
   LastKey:=Node^.PreviousKey;
  end;
  CountNodes(Node^.Left);
  CountNodes(Node^.Right);
  dispose(Node);
  Node:=nil;
 end;
 procedure DoInsertNode(const Node:TBESENSelfBalancedTreeNode);
 var n,s:PBESENSelfBalancedTreeNode;
     LessThan:boolean;
 begin
  new(n);
  n^.Key:=Node.Key;
  n^.Value:=Node.Value;
  n^.Parent:=nil;
  n^.Left:=nil;
  n^.Right:=nil;
  n^.Level:=0;
  s:=RootNode;
  LessThan:=true;
  while (LessThan and assigned(s^.Left)) or ((not LessThan) and assigned(s^.Right)) do begin
   if LessThan then begin
    s:=s^.Left;
   end else begin
    s:=s^.Right;
   end;
   LessThan:=n^.Key<s^.Key;
  end;
  if LessThan then begin
   s^.Left:=n;
  end else begin
   s^.Right:=n;
  end;
  n^.Parent:=s;
  if assigned(LastKey) then begin
   n^.PreviousKey:=LastKey;
   LastKey^.NextKey:=n;
   LastKey:=n;
  end else begin
   FirstKey:=n;
   LastKey:=n;
  end;
  if not MoreOptimize then begin
   RebalanceAfterLeafAdd(n);
  end;
 end;
 procedure RepairNodes(var Node:PBESENSelfBalancedTreeNode);
 begin
  if not assigned(Node) then begin
   exit;
  end;
  RepairNodes(Node^.Left);
  RepairNodes(Node^.Right);
  if assigned(Node^.Left) and assigned(Node^.Right) then begin
   Node^.Level:=Node^.Left^.Level+1;
  end else begin
   Node^.Level:=1;
  end;
 end;
 procedure ReinsertNodesForRepair(LowNode,HighNode:integer);
 var MiddleNode:integer;
 begin
  if HighNode<LowNode then begin
   exit;
  end;
  MiddleNode:=LowNode+((HighNode-LowNode) div 2);
  DoInsertNode(Nodes[MiddleNode]);
  Nodes[MiddleNode].Key:='';
  ReinsertNodesForRepair(LowNode,MiddleNode-1);
  ReinsertNodesForRepair(MiddleNode+1,HighNode);
 end;
 procedure ReinsertNodes(LowNode,HighNode:integer);
 var i:integer;
 begin
  for i:=LowNode to HighNode do begin
   DoInsertNode(Nodes[i]);
   Nodes[i].Key:='';
  end;
 end;
var i:integer;
begin
 if not assigned(Node) then begin
  exit;
 end;
 try
  Nodes:=nil;
  NodeCount:=0;
  CountNodes(Node);
  SetLength(Nodes,NodeCount);
  NodeIndex:=0;
  CollectNodes(Node);
  FreeNodes(Node);
  if MoreOptimize then begin
   ReinsertNodesForRepair(0,length(Nodes)-1);
   RepairNodes(RootNode^.Left);
  end else begin
   ReinsertNodes(0,length(Nodes)-1);
  end;
  for i:=0 to length(Nodes)-1 do begin
   Nodes[i].Key:='';
  end;
  SetLength(Nodes,0);
 except
 end;
end;

function TBESENSelfBalancedTree.Find(const Key:TBESENString;var Value:TBESENSelfBalancedTreeValue):boolean;
var n:PBESENSelfBalancedTreeNode;
begin
 n:=FindNode(Key);
 if assigned(n) then begin
  Value:=n^.Value;
  result:=true;
 end else begin
  fillchar(Value,sizeof(TBESENSelfBalancedTreeValue),#0);
  result:=false;
 end;
end;

procedure TBESENSelfBalancedTree.Optimize;
begin
 OptimizeNode(RootNode^.Left,true);
end;

function TBESENSelfBalancedTree.Keys:TBESENSelfBalancedTreeKeys;
var CurrentNode:PBESENSelfBalancedTreeNode;
    Count:integer;
begin
 result:=nil;
 Count:=0;
 CurrentNode:=FirstKey;
 while assigned(CurrentNode) do begin
  inc(Count);
  CurrentNode:=CurrentNode^.NextKey;
 end;
 SetLength(result,Count);
 Count:=0;
 CurrentNode:=FirstKey;
 while assigned(CurrentNode) do begin
  result[Count]:=CurrentNode^.Key;
  inc(Count);
  CurrentNode:=CurrentNode^.NextKey;
 end;
end;

function TBESENSelfBalancedTree.GetValue(Key:TBESENString):TBESENSelfBalancedTreeValue;
begin
 Find(Key,result);
end;

procedure TBESENSelfBalancedTree.SetValue(Key:TBESENString;Value:TBESENSelfBalancedTreeValue);
begin
 Insert(Key,Value);
end;

end.
