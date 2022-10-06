#!/usr/bin/ruby

require_relative 'shared_localization_utilities'

# String to remove
keyToRemove = ARGV[0]

if keyToRemove.nil? || keyToRemove.nil?
    puts "Expected 1 Argument for Key to remove"
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
        keyValueMapping = getFileStringMapping(localisedFileData)
        if keyValueMapping.key?(keyToRemove)
            # Sorting array to write in sorted way
            localisedValuesArray = keyValueMapping.sort.to_h.map do |key, value|
                if key != keyToRemove
                    "\"#{key}\" = \"#{value}\";"
                end                
            end
    
            # write to file
            File.write("./#{baseDirectory}/#{directory}/#{localisedStringFileName}", localisedValuesArray.join("\n"), mode: "w")

            puts "String removed successfully in #{directory}/#{localisedStringFileName} file"
        else
            puts "String with given key doesn't exist in #{directory}/#{localisedStringFileName} file"
            exit(false)
        end
        
end
