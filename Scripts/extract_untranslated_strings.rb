#!/usr/bin/ruby

require 'fileutils'
require_relative 'shared_localization_utilities'

# Base directory
baseDirectory = "path-to-localization-files-folder/Localization"
localisedStringFileName = "Localizable.strings"
extractedDirectoryName = "untranslated_strings"

puts "Started analyzing untranslated strings"
# base file
baseFile = File.open("./#{baseDirectory}/Base.lproj/#{localisedStringFileName}", "r")
baseFileData = baseFile.readlines.map(&:chomp)

baseFileStringMapping = getFileStringMapping(baseFileData)

directories = getAllFoldersFromDirectory(baseDirectory)

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