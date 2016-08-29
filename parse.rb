require 'nokogiri'
require 'sqlite3'

module ParseSML
  sql = 'INSERT INTO searchIndex(name, type, path) VALUES (?, ?, ?)'

  class SMLdash

    def initialize(docset)
      @path = File.join(File.dirname(__FILE__), "_output/#{docset}/Contents/")
      @html_path = File.join(@path, "Resources/Documents/sml-family.org/Basis/")
      @index = File.join(@html_path, "manpages.html")
      @sql_path = File.join(@path, "Resources/docSet.dsidx")
      @db = self.generate_database
    end

    def generate_database
      @db = SQLite3::Database.new(@sql_path)
      @db.busy_timeout = 100
      @db.execute <<-SQL
       CREATE TABLE searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT,
                                path TEXT);
       CREATE UNIQUE INDEX anchor ON searchIndex(name, type, path);
       SQL
    end

    def sql_insert(name, type, path)
      @db.execute(sql, name, type, path)
    end

  end
end

def check_doc_type doc
  sample = doc.css('h4').collect { |x| x.content }
  sample
end

def get_file name
  File.open(File.join(File.dirname(__FILE__), "sml-family.org/Basis/" + name))
end

# doc_file = ARGV.first
# file_name = ARGV.first

# puts "Parsing #{doc_file}:"
# tst = File.join(File.dirname(__FILE__), "sml-family.org/Basis/array.html")
# doc = Nokogiri::HTML(File.open(tst))

# doc2 = Nokogiri::HTML(get_file "unix.html");
# res = check_doc_type doc2
docset="standardml.docset"
tst = ParseSML::SMLdash.new
