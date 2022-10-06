#check if value is valid string
def isValidKeyValueLocalisationString(value) 
    return value.include?("=") && value.scan(/"/).count == 4  && value.chars.last == ";"
end

# Get all language directory and extract un-translated strings and write to file
def getAllFoldersFromDirectory(directoryName)
    return Dir.entries("./#{directoryName}").select  do |entry|
        if entry.include?(".lproj")        
            file = File.join("./#{directoryName}",entry)
            File.directory?(file) && !(entry =='.' || entry == '..')     
        else
            false
        end  
    end  
end


# Exmple string = "Not Connected" = "Connected";
#key value extraction
def extractKeyValueFromLocalisationString(value)
    key = value.partition("=").first # "Not Connected" 
    key = key.partition("\"").last # Not Connected"
    key = key.partition("\"").first # Not Connected

    keyValue = value.partition("=").last #  "Connected";
    keyValue = keyValue.partition("\"").last # Connected";
    keyValue = keyValue.partition("\"").first # Connected

    return key, keyValue
end

# map strings to key-value pair
def getFileStringMapping(fileData)
    fileStringMapping = Hash.new
    for value in fileData do
        if isValidKeyValueLocalisationString(value)
            key, keyValue = extractKeyValueFromLocalisationString(value)
            fileStringMapping[key] = keyValue
        end
    end   
    return fileStringMapping
    
end

# extract un-translated string from given files data and mapping string
def getUnTransalatedStringArray(localisedFileData, baseFileStringMapping)
    unLocalisedValuesArray = Array.new
    for value in localisedFileData do
        if isValidKeyValueLocalisationString(value)

            key, keyValue = extractKeyValueFromLocalisationString(value)
            # we are checking base file text value to match with localisation file text value
            if baseFileStringMapping[key] == keyValue
                unLocalisedValuesArray.push("\"#{keyValue}\"")
            end
        end
    end
    return unLocalisedValuesArray
end

# TODO: update once we get final translated string
# check translated file strings
def isValidKeyValueTranslatedString(value) 
    return value.include?("=") && value.scan(/"/).count == 4
end

# map strings to key-value pair
def getTranslatedFileStringMapping(fileData)
    fileStringMapping = Hash.new
    for value in fileData do
        if isValidKeyValueTranslatedString(value)
            key, keyValue = extractKeyValueFromLocalisationString(value)
            fileStringMapping[key] = keyValue
        end
    end   
    return fileStringMapping
end
