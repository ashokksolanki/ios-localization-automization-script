#!/usr/bin/ruby

# Base directory
baseDirectory = "path-to-localization-folder-/Localization"
localisedStringFileName = "Localizable.strings"

# Get all language directory and extract un-translated strings and write to file
directories = Dir.entries("./#{baseDirectory}").select  do |entry|
    if entry.include?(".lproj")        
        file = File.join("./#{baseDirectory}",entry)
        File.directory?(file) && !(entry =='.' || entry == '..')     
    else
        false
    end
end

#check if value is valid string
def isValidKeyValueLocalisationString(value) 
    return value.include?("=") && value.scan(/"/).count == 4  && value.chars.last == ";"
end

#key value extraction
def extractKeyValueFromLocalisationString(value)
    key = value.partition("=").first
    keyValue = value.partition("=").last
    keyValue = keyValue.partition(";").first
    return key, keyValue
end

# New string to add
keyToAdd = ARGV[0]
valueToAdd = ARGV[1]
newStringToInsert = "\"#{keyToAdd}\" = \"#{valueToAdd}\";"
keyToAdd = "\"#{keyToAdd}\" "

for directory in directories do
    dirName = directory.partition(".").first
    
        # Localised file data with key value pairing
        localisedFile = File.open("./#{baseDirectory}/#{directory}/#{localisedStringFileName}", "r")
        localisedFileData = localisedFile.readlines.map(&:chomp)
        localisedValuesArray = Array.new
        keyValueMapping = Hash.new
        for value in localisedFileData do
            key, keyValue = extractKeyValueFromLocalisationString(value)
            keyValueMapping[key] = keyValue
            if isValidKeyValueLocalisationString(value)
                localisedValuesArray.push(value)
            end
        end
        
        if keyValueMapping.key?(keyToAdd)
            puts "Key already exists, please re-check your key-value"
            return
        else
            localisedValuesArray.push(newStringToInsert) 
            puts "Added new string successfully"
        end        

        # Sorting array to write in sorted way
        localisedValuesArray.sort!

        # write to file
        File.write("./#{baseDirectory}/#{directory}/#{localisedStringFileName}", localisedValuesArray.join("\n"), mode: "w")
end
