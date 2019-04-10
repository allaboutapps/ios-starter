#!/usr/bin/ruby
require "fileutils"
require "builder"
require "find"

class Pair
	attr_accessor :key, :value
	def initialize(key, value)
		@key = key
		@value = value
	end
end

def generate_strings_dict(strings_file_path)
	puts("- Generate strings dict for " + strings_file_path)

	# Parse strings file
	pairs = File.readlines(strings_file_path)
	.select { |line| line.start_with?("\"") }
	.map { |line| 
		split = line.split("\"")
		Pair.new(split[1], split[3])
	}
	.select { |pair| 
		split = pair.key.split("_")
		["zero", "one", "two", "few", "many", "other"].include?(split[-1])	
	}
	.group_by { |pair|
		pair.key.split("_")[0...-1].join("_")
	}
	.select { |key, array|
		array.count > 1
	}

	# Generate XML
	output = ""
	xml = Builder::XmlMarkup.new(:target => output, :indent => 4)
	xml.instruct! :xml, :encoding => "UTF-8"
	xml.declare! :DOCTYPE, :plist, :PUBLIC , "-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd"
	xml.plist(:version => "1.0") {
		xml.dict {
			pairs.each { |key, array|
				xml.key(key + "_other")
				xml.dict {
					xml.key("NSStringLocalizedFormatKey")
					xml.string("\%#\@VARIABLE\@")
					xml.key("VARIABLE")
					xml.dict {
						xml.key("NSStringFormatSpecTypeKey")
						xml.string("NSStringPluralRuleType")
						xml.key("NSStringFormatValueTypeKey")
						xml.string("d")
						array.each { |pair|
							pluralize_key = pair.key.split("_")[-1]
							xml.key(pluralize_key)
							xml.string(pair.value)
						}
					}
				}
			}
		}
	}

	# Write to file
	new_file_path = strings_file_path.split(".")[0...-1].join(".") + ".stringsdict"
	File.write(new_file_path, output)
end

USAGE = <<ENDUSAGE
Usage:
    #{__FILE__} [-h] [-d] path
ENDUSAGE

HELP = <<ENDHELP
Generates .stringsdict files for .strings file
    -h, --help       Show this help.
    -d, --directory  Scans the provided path for .strings files

ENDHELP

ARGS = { } # Setting default values
UNFLAGGED_ARGS = [ :path ] # Bare arguments (no flag)
next_arg = UNFLAGGED_ARGS.first
ARGV.each do |arg|
	case arg
	when '-h','--help'      then ARGS[:help]      = true
	when '-d','--directory' then ARGS[:directory] = true
	else
		if next_arg
			ARGS[next_arg] = arg
			UNFLAGGED_ARGS.delete( next_arg )
		end
		next_arg = UNFLAGGED_ARGS.first
	end
end

if ARGS[:help] or !ARGS[:path]
	puts USAGE
	puts HELP if ARGS[:help]
	exit
end

if !ARGS[:directory] and File.extname(ARGS[:path]) != ".strings"
	puts "File is not a .strings file"
	puts USAGE
	puts HELP if ARGS[:help]
	exit 1
end

if ARGS[:directory] and !File.directory?(ARGS[:path])
	puts "Path is not a directory"
	puts USAGE
	puts HELP if ARGS[:help]
	exit 1
end

if ARGS[:directory]
	Find.find(ARGS[:path]) do |path|
		generate_strings_dict(path) if File.extname(path) == ".strings"
	end
else
	generate_strings_dict(ARGS[:path])	
end

