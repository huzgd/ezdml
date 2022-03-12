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
unit BESENPointerList;
{$i BESEN.inc}

interface

uses BESENConstants,BESENTypes;

type PBESENPointerArray=^TBESENPointerArray;
     TBESENPointerArray=array[0..(2147483647 div sizeof(pointer))-1] of pointer;

     TBESENPointerList=class
      private
       FList:PBESENPointerArray;
       FCount,FSize:integer;
       function GetItem(index:integer):pointer;
       procedure SetItem(index:integer;Value:pointer);
       function GetItemPointer(index:integer):pointer;
      public
       constructor Create;
       destructor Destroy; override;
       procedure Clear;
       function Add(Item:pointer):integer;
       procedure Insert(index:integer;Item:pointer);
       procedure Delete(index:integer);
       function Remove(Item:pointer):integer;
       function Find(Item:pointer):integer;
       function IndexOf(Item:pointer):integer;
       procedure Exchange(Index1,Index2:integer);
       procedure SetCapacity(NewCapacity:integer);
       procedure SetCount(NewCount:integer);
       property Count:integer read FCount;
       property Capacity:integer read FSize write SetCapacity;
       property Item[index:integer]:pointer read GetItem write SetItem; default;
       property Items[index:integer]:pointer read GetItem write SetItem;
       property PItems[index:integer]:pointer read GetItemPointer;
     end;

implementation

constructor TBESENPointerList.Create;
begin
 inherited Create;
 FCount:=0;
 FSize:=0;
 FList:=nil;
 Clear;
end;

destructor TBESENPointerList.Destroy;
begin
 Clear;
 inherited Destroy;
end;

procedure TBESENPointerList.Clear;
begin
 FCount:=0;
 FSize:=0;
 ReallocMem(FList,0);
end;

procedure TBESENPointerList.SetCapacity(NewCapacity:integer);
begin
 if (NewCapacity>=0) and (NewCapacity<high(TBESENPointerArray)) then begin
  NewCapacity:=(NewCapacity+256) and not 255;
  if FSize<>NewCapacity then begin
   ReallocMem(FList,NewCapacity*sizeof(pointer));
   if FSize<NewCapacity then begin
    FillChar(FList^[FSize],(NewCapacity-FSize)*sizeof(pointer),#0);
   end;
   FSize:=NewCapacity;
  end;
 end;
end;

procedure TBESENPointerList.SetCount(NewCount:integer);
begin
 if (NewCount>=0) and (NewCount<high(TBESENPointerArray)) then begin
  if NewCount<FCount then begin
   FillChar(FList^[NewCount],(FCount-NewCount)*sizeof(pointer),#0);
  end;
  SetCapacity(NewCount);
  FCount:=NewCount;
 end;
end;

function TBESENPointerList.Add(Item:pointer):integer;
begin
 result:=FCount;
 SetCount(result+1);
 FList^[result]:=Item;
end;

procedure TBESENPointerList.Insert(index:integer;Item:pointer);
var I:integer;
begin
 if (index>=0) and (index<FCount) then begin
  SetCount(FCount+1);
  for I:=FCount-1 downto index do FList^[I+1]:=FList^[I];
  FList^[index]:=Item;
 end else if index=FCount then begin
  Add(Item);
 end else if index>FCount then begin
  SetCount(index);
  Add(Item);
 end;
end;

procedure TBESENPointerList.Delete(index:integer);
var I,J,K:integer;
begin
 if (index>=0) and (index<FCount) then begin
  K:=FCount-1;
  J:=index;
  for I:=J to K-1 do FList^[I]:=FList^[I+1];
  SetCount(K);
 end;
end;

function TBESENPointerList.Remove(Item:pointer):integer;
var I,J,K:integer;
begin
 result:=-1;
 K:=FCount;
 J:=-1;
 for I:=0 to K-1 do begin
  if FList^[I]=Item then begin
   J:=I;
   break;
  end;
 end;
 if J>=0 then begin
  dec(K);
  for I:=J to K-1 do FList^[I]:=FList^[I+1];
  SetCount(K);
  result:=J;
 end;
end;

function TBESENPointerList.Find(Item:pointer):integer;
var I:integer;
begin
 result:=-1;
 for I:=0 to FCount-1 do begin
  if FList^[I]=Item then begin
   result:=I;
   exit;
  end;
 end;
end;

function TBESENPointerList.IndexOf(Item:pointer):integer;
var I:integer;
begin
 result:=-1;
 for I:=0 to FCount-1 do begin
  if FList^[I]=Item then begin
   result:=I;
   exit;
  end;
 end;
end;

procedure TBESENPointerList.Exchange(Index1,Index2:integer);
var TempPointer:pointer;
begin
 if (Index1>=0) and (Index1<FCount) and (Index2>=0) and (Index2<FCount) then begin
  TempPointer:=FList^[Index1];
  FList^[Index1]:=FList^[Index2];
  FList^[Index2]:=TempPointer;
 end;
end;

function TBESENPointerList.GetItem(index:integer):pointer;
begin
 if (index>=0) and (index<FCount) then begin
  result:=FList^[index];
 end else begin
  result:=nil;
 end;
end;

procedure TBESENPointerList.SetItem(index:integer;Value:pointer);
begin
 if (index>=0) and (index<FCount) then begin
  FList^[index]:=Value;
 end;
end;

function TBESENPointerList.GetItemPointer(index:integer):pointer;
begin
 if (index>=0) and (index<FCount) then begin
  result:=@FList^[index];
 end else begin
  result:=nil;
 end;
end;

end.
 