--------------------------------------------------------
--Lua Behavior Tree
--------------------------------------------------------


-------------------------------------------------------------
-- Instance BlackBoard
-- member : new() -- creates a new istance
-- member : setValue(_key, _value) -- sets a key and value
-- member : getValue(_key) -- gets a value by key
-- member : printAll() -- prints all the key value pairs

Blackboard = {}


function Blackboard:new(_name)

	self.name = _name
	self.__index = Blackboard
	local instance = setmetatable({name = _name , KeyValues = {}}, self)
    return instance

end

function Blackboard:setValue(_key, _value)
	local newEntry = { ["name"]  = _key , ["value"]= _value}
	--print(self)
	table.insert(self.KeyValues, newEntry) -- inset into table
end


function Blackboard:getValue(_key)
	--print(self.KeyValues[1]["value"])
	i = 1
	while i< #self.KeyValues +1 do
		if self.KeyValues[i]["name"] == _key then
			return self.KeyValues[i]["value"]
		else
		 print( "--- Blackboard has no such value " .. _key)
		end

		i = i+1
	end
end

function Blackboard:PrintAll()
	i=1
	while i< #self.KeyValues +1 do
		print ("name : "..self.KeyValues[i]["name"] .." value : ".. self.KeyValues[i]["value"])
		i = i+1
	end

end
--------------------------------------------------------------------------------------



-- internal node statuses
Status = {"Invalid","Success","Failure","Running"}



-- Main node class
Node = {}

function Node:new(_name)
	self.name = "unasigned"
	self.__index = Node
	local instance = setmetatable({name = _name,status = Status[1]}, self)
    return instance
end


function Node:tick()
	print("--- tick " .. self.name )
	if self.status ~= Status[4] then
		print("----Initialising  " .. self.name )
		self:initialise()
	end
	self:update()
	return self.status
end


-------------------------------------------------
BehaviorTree = {}

function BehaviorTree:new()
	self.__index = BehaviorTree
	setmetatable (self , {__index = Node }) --inheritance from composit
	local instance = setmetatable({name = _name , status = Status[1] ,root = nil}, self)
    return instance

end

function BehaviorTree:setRoot(_node)
		self.root = _node
	end

function BehaviorTree:update()
	return self.root:tick()
end



--------------------------------------------------------
-- The Selector composite ticks each child node in order.
-- If a child succeeds or runs, the selector returns the same status.
-- In the next tick, it will try to run each child in order again.
-- If all children fails, only then does the selector fail.

Selector = {}

function Selector:new(_name)
	self.__index = Selector
	setmetatable (self , {__index = Node }) --inheritance from composit
	local instance = setmetatable({name = _name , status = Status[1] ,Selectors_Children ={} }, self)
    return instance
end


function Selector:addChild(_name ,_node)
	--print ("-----".._node.name.."-----")
	local Child_Node = {["name"] = _node.name , ["node"] = _node}
	table.insert(self.Selectors_Children, Child_Node) -- inset into table
    --printing it out
	--print ("------------------Selectors_Children--------------------------")
	--for key, value in  pairs(Selector.Selectors_Children) do
	--	print(value)
	--	for key1, value1 in  pairs(value) do
	--	if key1 == "name" then
	--		print( value1)
	--	end
	--	if key1 == "node" then
	--		print( "node Table")
	--	end
	--	end
	--end
	--print ("-------------------end -----------------")
end


function Selector:initialise()
	--print ("selector Initialising ")
	self.status = Status[4]
end

function Selector:update()
	--print ("> Selector Updating ".. self.name)
	-- run it at a while loop
	local i = 1
	--print (" -- Number of Selectors children  "..#Selector.Selectors_Children)
	while i< #self.Selectors_Children + 1 do
		--print ("current Status of the node ".. Selector.Selectors_Children[i]["node"].status)
		local state = self.Selectors_Children[i]["node"]:tick() -- tick is to return the status
		--print ("local state "..state)
		self.status = state
		print (">" ..self.Selectors_Children[i]["node"]["name"])
		--print (Selector.status.. " is the selectors current state")
		if self.status ~= Status[3] then
			return self.status
		end
	i = i + 1
	end
	return Status[3]
end


-------------------------------------------------
-- The Sequence composite ticks each child node in order.
-- If a child fails or runs, the sequence returns the same status.
-- In the next tick, it will try to run each child in order again.
-- If all children succeeds, only then does the sequence succeed.

Sequence = {}

function Sequence:new(_name)
	self.__index = Sequence
	setmetatable (self , {__index = Node}) --inheritance from composit
	local instance = setmetatable({name = _name , status = Status[1] ,Node_collection = {}  }, self)
	return instance
end


function Sequence:initialise()
	self.status = Status[4]
end


function Sequence:update()
	--print ("> Sequence Updating " .. self.name)
	local i = 1
	--print (" -- Number of Selectors children  "..#self.Node_collection)
	while i< #self.Node_collection + 1 do

		--print ("current Status of the node ".. Selector.Selectors_Children[i]["node"].status)
		local state = self.Node_collection[i]["node"]:tick() -- tick is to return the status
		--print ("local state "..state)
		self.status = state
		print ("> " ..self.Node_collection[i]["node"]["name"])
		--print (Selector.status.. " is the selectors current state")

		if self.status ~= Status[2] then
			return self.status
		end
	i = i + 1
	end
	return Status[2]
end


function Sequence:addChild(_name , _node)
	--print ("-----".._node.name.."-----")
	local Child_Node = {["name"] = _node.name , ["node"] = _node}
	table.insert(self.Node_collection, Child_Node) -- inset into table

end



------------------------------------------------------------------------------------
--    Leaf Nodes
-------------------------------------------------------------------------------------
Assult ={}

function Assult:new(_name)
	Assult.__index = Assult
	setmetatable (Assult , {__index = Node}) --inheritance from composit
	local instance = setmetatable({name = _name , status = Status[1]  }, self)
	return instance
end

function Assult:initialise()
	self.status = Status[4] -- set state to running
end
function Assult:update()
	--print ("update is called")
	self.status = Status[3] -- set state to fail so it loops to the next call for test purposes
end
--------------------------------------------------------------------------------------

Patrol = {}

function Patrol:new(_name)
	Patrol.__index = Patrol
	setmetatable (Patrol , {__index = Node}) --inheritance from composit
	local instance = setmetatable({name = _name , status = Status[1]  }, self)
	return instance

end

function Patrol:initialise()
	self.status = Status[4]
end

function Patrol:update()
	--print("Patroling update" )
	self.status = Status[2]
end
----------------------------------------------------------------


