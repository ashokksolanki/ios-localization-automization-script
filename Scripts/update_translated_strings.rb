#!/usr/bin/ruby
require_relative 'shared_localization_utilities'

# Base directory
baseDirectory = "path-to-localization-files-folder/Localization"
localisedStringFileName = "Localizable.strings"
translatedDirectory = "translated_strings"

if !Dir.exist?(translatedDirectory)
    puts "Expected translated strings folder name #{translatedDirectory} with all language name files"
    exit(false)
end

# Get all language directory and extract un-translated strings and write to file
directories = getAllFoldersFromDirectory(baseDirectory)

for directory in directories do
    dirName = directory.partition(".").first
    
    # update string for each language except base language file
    if dirName != "Base"
       if File.file?("./#{translatedDirectory}/#{dirName}.txt")
        translatedFile = File.open("./#{translatedDirectory}/#{dirName}.txt", "r") 
        translatedFileData = translatedFile.readlines.map(&:chomp)
        translatedStringsMapping = getTranslatedFileStringMapping(translatedFileData)
        
        fileToUpdate = File.open("./#{baseDirectory}/#{directory}/#{localisedStringFileName}", "r") 
        fileToUpdateData = fileToUpdate.readlines.map(&:chomp)
        updateValuesStringMapping = Hash.new

        for lineOfTextOfLocalisationFile in fileToUpdateData do
            if isValidKeyValueLocalisationString(lineOfTextOfLocalisationFile)
                key, keyValue = extractKeyValueFromLocalisationString(lineOfTextOfLocalisationFile)
                if translatedStringsMapping.key?(keyValue)
                    updateValuesStringMapping[key] = translatedStringsMapping[keyValue]
                else
                    updateValuesStringMapping[key] = keyValue
                end
            end
        end
        
        # sort and map as per localised string file
        updatedLocalisedValuesArray = updateValuesStringMapping.sort.to_h.map do |key, value|
            "\"#{key}\" = \"#{value}\";"
        end
        
        # write to file
        File.write("./#{baseDirectory}/#{directory}/#{localisedStringFileName}", updatedLocalisedValuesArray.join("\n"), mode: "w")
        puts "Updated string successfully in #{directory}/#{localisedStringFileName} file"
       elsif 
        puts "Translated file doesn't exist for #{directory}/#{localisedStringFileName} file" 
       end
    end
end
