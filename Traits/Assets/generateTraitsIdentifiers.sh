#!/usr/bin/ruby

require 'rexml/document'
include REXML

class String
    # Only capitalize first letter of a string
    def capitalize_first
        letters = split('')
        letters.first.upcase!
        letters.join
    end

    # Only downcase first letter of a string
    def downcase_first
        letters = split('')
        letters.first.downcase!
        letters.join
    end
end

def normalizedName(name)
    map = { 'view' => 'UIView',
            'label' => 'UILabel',
            'constraint' => 'NSLayoutConstraint' }
    map[name] || name
end

def normalize_identifier(identifier)
    components = identifier.split('.')
    components = components.map(&:capitalize_first)
    components.join.downcase_first
end

def parse_file(path, uniqueIdentifiers)
    file = File.new(path)
    doc = Document.new(file)

    XPath.each(doc, "//userDefinedRuntimeAttribute[@keyPath='traitSpec']/../parent::*") do |container|
        attrib = XPath.first(container, 'userDefinedRuntimeAttributes')
        traits = attrib.elements.select { |e| e.attributes['keyPath'] == 'traitSpec' }.map { |e| e.attributes['value'] }

        class_name = normalizedName(container.name)
        unless (customClass = container.attributes['customClass']).nil?
            class_name = customClass
        end

        traits.each do |t|
            current = uniqueIdentifiers[t] || Set.new
            current.add(class_name)
            uniqueIdentifiers[t] = current
        end
    end
end

uniqueIdentifiers = {}

Dir.glob("#{ARGV[0] || "."}/**/*.{storyboard,xib}").each {|path| parse_file(path, uniqueIdentifiers) }

puts "import Traits\n\n"
puts "enum TraitIdentifier {\n"

functions = "\n\t\tprivate var entry: TraitIdentifierEntry {\n\t\t\tswitch self {\n"

uniqueIdentifiers.each do |identifier, classes|
    class_string = classes.map { |c| "#{c}.self" }.join(', ')
    normalized = normalize_identifier(identifier)
    puts "\t\tcase #{normalized}\n"

    functions += "\t\t\t\tcase .#{normalized}:\n\t\t\t\t\treturn TraitIdentifierEntry(\"#{identifier}\", classes: [#{class_string}])\n"

    # puts "\t\tstatic let #{normalize_identifier(identifier)} = TraitIdentifierEntry(\"#{identifier}\", classes: [#{class_string}])\n"
end

functions += "\t\t\t}\n\t\t}\n"

functions += "\n\t\tvar identifier: String { return self.entry.identifier }"

puts functions

puts "}\n"
puts '
extension TraitsProvider.Specification {
    init(typedSpec: [TraitIdentifier: [Trait]]) {
        var dict = [String: [Trait]]()

        _ = typedSpec.map { identifier, list in
            dict[identifier.identifier] = list
        }

        self.init(specs: dict)
    }
}
'
