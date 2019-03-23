class Student

  attr_accessor :name, :location, :twitter, :facebook, :linkedin, :github, :blog, :profile_quote, :bio, :profile_url 

  @@all = []

  def initialize(student_hash)
    #takes a hash and iterates through the hash
    #assigning instance property values
    #called metaprogramming
    student_hash.each{|key, value| self.send(("#{key}="), value)}
    @@all << self 
  end

  def self.create_from_collection(students_array)
    #create students from the array of hashes gleaned from index.html
       students_array.each do |x|
        student = Student.new(x)
      end
    
  end

  def add_student_attributes(attributes_hash)
    #add additional attributes for the student from their profile page
    attributes_hash.each{|key, value| self.send(("#{key}="), value)}
    self
  end

  def self.all
    @@all 
  end
end

