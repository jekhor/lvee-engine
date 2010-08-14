class WikiPage < ActiveRecord::Base
  belongs_to :user
  set_locking_column("version" )
  acts_as_versioned

  validates :body, :user_id, :presence => true
  validates :name, :uniqueness => true, :presence => true

  def self.all
    find(:all, :order => "name")
  end

  def self.find_version(id, version)
    Version.find(:first, :conditions=>{:wiki_page_id => id, :version => version})
  end

  def find_version(version)
    WikiPage.find_version(self.id, version)
  end
end
