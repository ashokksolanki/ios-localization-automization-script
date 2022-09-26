#!/usr/bin/ruby

require 'fileutils'

# Base directory
baseDirectory = "path-to-localization-folder-/Localization"
localisedStringFileName = "Localizable.strings"
extractedDirectoryName = "untranslated_strings"

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
                unLocalisedValuesArray.push(keyValue)
            end
        end
    end
    return unLocalisedValuesArray
end

#check 
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

puts "Started analyzing untranslated strings"
# base file
baseFile = File.open("./#{baseDirectory}/Base.lproj/#{localisedStringFileName}", "r")
baseFileData = baseFile.readlines.map(&:chomp)

baseFileStringMapping = getFileStringMapping(baseFileData)

# Get all language directory and extract un-translated strings and write to file
directories = Dir.entries("./#{baseDirectory}").select  do |entry|
    if entry.include?(".lproj")        
        file = File.join("./#{baseDirectory}",entry)
        File.directory?(file) && !(entry =='.' || entry == '..')     
    else
        false
    end
end

FileUtils.rm_rf(extractedDirectoryName)
Dir.mkdir(extractedDirectoryName)

for directory in directories do
    dirName = directory.partition(".").first
    
    # Un-Localised file data with key value pairing
    if dirName != "Base"
        unLocalisedFile = File.open("./#{baseDirectory}/#{directory}/#{localisedStringFileName}", "r")
        unLocalisedFileData = unLocalisedFile.readlines.map(&:chomp)
        unLocalisedValuesArray = getUnTransalatedStringArray(unLocalisedFileData, baseFileStringMapping)
        
        if unLocalisedValuesArray.count > 0
             # write to file
            File.write("./#{extractedDirectoryName}/#{dirName}.txt", unLocalisedValuesArray.join("\n"), mode: "w")            
        else
            puts "There is no un-translated string for #{dirName} language"
        end

    end
end

puts "Finished analyzing untranslated strings and please check #{extractedDirectoryName} folder"