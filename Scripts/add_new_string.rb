#!/usr/bin/ruby

require_relative 'shared_localization_utilities'

# New string to add
keyToAdd = ARGV[0]
valueToAdd = ARGV[1]
if keyToAdd.nil? || valueToAdd.nil?
    puts "Expected 2 Arguments first for Key and second for Value"
    exit(false)
end

# Base directory
baseDirectory = "path-to-localization-files-folder/Localization"
localisedStringFileName = "Localizable.strings"

# Get all language directory and extract un-translated strings and write to file
directories = getAllFoldersFromDirectory(baseDirectory)

for directory in directories do
    dirName = directory.partition(".").first
    
        # Localised file data with key value pairing
        localisedFile = File.open("./#{baseDirectory}/#{directory}/#{localisedStringFileName}", "r")
        localisedFileData = localisedFile.readlines.map(&:chomp)
        keyValueMapping = Hash.new
        for lineOfTextOfLocalisationFile in localisedFileData do
            if isValidKeyValueLocalisationString(lineOfTextOfLocalisationFile)
                key, keyValue = extractKeyValueFromLocalisationString(lineOfTextOfLocalisationFile)
                keyValueMapping[key] = keyValue    
            end
        end
        
        if keyValueMapping.key?(keyToAdd)
            puts "Key already exists, please re-check your key-value in #{directory}/#{localisedStringFileName} file"
            exit(false)
        else
            keyValueMapping[keyToAdd] = valueToAdd    
            puts "Added new string successfully in #{directory}/#{localisedStringFileName} file"
        end        

        localisedValuesArray = keyValueMapping.sort.to_h.map do |key, value|
            "\"#{key}\" = \"#{value}\";"
        end

        # write to file
        File.write("./#{baseDirectory}/#{directory}/#{localisedStringFileName}", localisedValuesArray.join("\n"), mode: "w")
end
