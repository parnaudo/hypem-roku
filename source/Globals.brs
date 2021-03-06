function truncateText(text as String, max=200 as Integer, suffix="..." as String) as String
	max = max - len(suffix)
	if len(text) <= max return text
	text = left(text, max)
	i = max
	while i > 0
		if instr(i, text, " ") <> 0 exit while
		i = i - 1
	end while
	return left(text, i-1) + suffix
end function

function getTime() as Integer
	return createObject("roDateTime").asSeconds()
end function

function createScreen(name as String) as Object
	port = createObject("roMessagePort") 
	screen = createObject("ro" + name + "Screen") 
	screen.setMessagePort(port)
	return screen
end function

function readJsonFile(path as String) as Object
	return parseJson(readAsciiFile("pkg:/"+path+".json"))
end function

function escapeQuery(transport as Object, params as Object) as String
	querystring = ""
	for each key in params
		value = params[key]
		if type(value) = "roInteger" then
			value = value.tostr()
		endif
    	querystring = querystring + "&"
    	querystring = querystring + transport.escape(key)
    	querystring = querystring + "="
    	querystring = querystring + transport.escape(value)
	end for
	return mid(querystring.trim(), 2)
end function

function mergeObjects(into as Object, from as Object) as Object
	if from = invalid then
		return into
	endif
	for each key in from
		into[key] = from[key]
	end for
	return into
end function

function arrayMap(arr as Object, mapper as Function) as Object
	mapped = []
	max = arr.count() - 1
	for i = 0 to max
		mapped[i] = mapper(arr[i])
	end for
	return mapped
end function