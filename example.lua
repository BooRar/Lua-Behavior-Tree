---------------------------------------------------
-- Example 
---------------------------------------------------
require "Lua_Behavior_tree.lua"

--blackboard test 
local randy = Blackboard:new("SecondBoard")
print("> BlackBoard Name"..Blackboard.name)

randy:setValue("food", "false")
randy:setValue("hungry", "true")
randy:setValue("banana", "true")
randy:setValue("fighter", "false")
randy:setValue("Mobname", "mega fun Beef")
randy:setValue("IsDanger", 2)

randy:getValue("buttons")
print ("> food Value = "..randy:getValue("food"))
print ("-----Print all ----")
randy:PrintAll()


local BT = BehaviorTree:new()

local ASS1 = Assult:new("Gun_Assult")
local ASS2 = Assult:new("Hand_Assult")
local PAT = Patrol:new("Patrol")

local Sel2 = Sequence:new("Sequence_2")
Sel2:addChild("PAT" ,PAT )


local Sel = Selector:new("Selector_1")
Sel:addChild("Assult_1" ,ASS1 )
Sel:addChild("Assult_2" , ASS2 )
Sel:addChild("PAT" ,PAT )
Sel:addChild("PAT" ,Sel2 )


local seq = Sequence:new("sequence")
seq:addChild("Se2", Sel)
seq:addChild("sel3", Sel2)

local i = 1
    while i<20 do
    
		BT:setRoot(PAT)
		BT:update()
		i = i + 1
end
