---This program reads a lua source code and formats it
--input file is given as the only argument and the output is written
--to stdout by default (shown on screen) which can easily be directed
--to a file
--usage: lua beautifier.lua input.lua > output.lua
--You can adjust the indentation by changing the value of INDENTATION below

---indentation (default is tab but it can be any number of
--spaces or tabs or even other strings
INDENTATION="\t"

---Checks if a string starts with another one (phrase)
--@param phrase the other string that is supposedly at the end of the string
--@return true if phrase is at the beginning of the string, false otherwise
function string:startsWith(phrase)
	ret=string.find(self,phrase,1,true)
	if ret==nil or ret~=1 then
		return false
	else
		return true
	end
end

---Checks if a string ends with another one (phrase)
--@param phrase the other string that is supposedly at the end of the string
--@return true if phrase is at the end of the string, false otherwise
function string:endsWith(phrase)
	local len=phrase:len();
	ret=string.find(self,phrase,-len,true)
	if ret==nil or ret~=self:len()-len+1 then
		return false
	else
		return true
	end
end

---trims a function (removes the spaces and tabs from its beginning and end"
--@param st
function trim(st)
	--indicates if the function did something. if it does, then to remove a mix
	--of tabs and spaces, it calls itself again with the remaining string
	local didSomething=false
	--remove spaces and tabs from the beginning of the string
	local s,e=st:find("^ +")
	if s~=nil then
		didSomething=true
		st=st:sub(e+1)
	end
	s,e=st:find("^\t+")
	if s~=nil then
		didSomething=true
		st=st:sub(e+1)
	end
	--remove spaces and tabs from the end of the string
	s,e=st:find(" +$")
	if s~=nil then
		didSomething=true
		st=st:sub(1,s-1)
	end
	s,e=st:find("\t+$")
	if s~=nil then
		didSomething=true
		st=st:sub(1,s-1)
	end
	if not didSomething then
		return st
	end

	return trim(st)
end

local filename=arg[1]

file = assert(io.open(filename, "r"))
if not file then
	print "file doesn't exist"
	return
else
	print "reading file"
end

---indentation for the current line
currIndent=0
---indentation for the next line
nextIndent=0
while true do
	line=file:read("*line")
	if not line then break end
	line=trim(line)
	--do the processing
	if (
	   line:startsWith("function") or
	   line:startsWith("repeat") or
	   line:startsWith("while") or
	   line:endsWith("then") or
	   line:endsWith("do") or
	   line:endsWith("{") ) and 
           not line:startsWith("--") -- may be deleted
	   then
		nextIndent=currIndent+1
	end

	if
	  line=="end" or
	  line=="}" or
	  line:startsWith("until") then
		currIndent=currIndent-1
		nextIndent=currIndent
	end

	if
	  line:startsWith("else") or
	  line:startsWith("elseif") then
		currIndent=currIndent-1
		nextIndent=currIndent+1
	end

	if line=="" then
		--don't indent empty lines
		print ""
	else
		print(string.rep(INDENTATION,currIndent)..line)
	end
	currIndent=nextIndent
end
file:close()
