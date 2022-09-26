#!/usr/bin/ruby

# Base directory
baseDirectory = "path-to-localization-folder-/Localization"
localisedStringFileName = "Localizable.strings"
translatedDirectory = "translated_strings"

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

# map strings to key-value pair
def getTranslatedFileStringMapping(fileData)
    fileStringMapping = Hash.new
    for value in fileData do
        if isValidKeyValueTranslatedString(value)
            key, keyValue = extractKeyValueFromLocalisationString(value)
            key = key.chop
            fileStringMapping[key] = keyValue
        end
    end   
    return fileStringMapping
end

# check localized file strings
def isValidKeyValueLocalisationString(value) 
    return value.include?("=") && value.scan(/"/).count == 4  && value.chars.last == ";"
end

# TODO: update once we get final translated string
# check translated file strings
def isValidKeyValueTranslatedString(value) 
    return value.include?("=") && value.scan(/"/).count == 4
end

#key value extraction
def extractKeyValueFromLocalisationString(value)
    key = value.partition("=").first
    keyValue = value.partition("=").last
    keyValue = keyValue.partition(";").first
    return key, keyValue
end

# Get all language directory and extract un-translated strings and write to file
directories = Dir.entries("./#{baseDirectory}").select  do |entry|
    if entry.include?(".lproj")        
        file = File.join("./#{baseDirectory}",entry)
        File.directory?(file) && !(entry =='.' || entry == '..')     
    else
        false
    end
end


for directory in directories do
    dirName = directory.partition(".").first
    
    # update string for each language except base language file
    if dirName != "Base"
        translatedFile = File.open("./#{translatedDirectory}/#{dirName}.txt", "r") 
        translatedFileData = translatedFile.readlines.map(&:chomp)
        translatedStringsMapping = getTranslatedFileStringMapping(translatedFileData)
        
        fileToUpdate = File.open("./#{baseDirectory}/#{directory}/#{localisedStringFileName}", "r") 
        fileData = fileToUpdate.readlines.map(&:chomp)
        updatedValuesArray = Array.new

        for value in fileData do
            if isValidKeyValueLocalisationString(value)
                key, keyValue = extractKeyValueFromLocalisationString(value)
                if translatedStringsMapping.key?(keyValue)
                    newValue = value.gsub! keyValue, "#{translatedStringsMapping[keyValue]}"
                    updatedValuesArray.push(newValue)
                else
                    updatedValuesArray.push(value)
                end
            end
        end
        
        updatedValuesArray.sort!
        
        # write to file
        File.write("./#{baseDirectory}/#{directory}/#{localisedStringFileName}", updatedValuesArray.join("\n"), mode: "w")
    end
end
