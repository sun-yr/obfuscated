require 'rails'
require 'support/active_record'
require 'lib/obfuscated'

class Post < ActiveRecord::Base
  has_obfuscated_id
  has_many :comments
end
class Comment < ActiveRecord::Base
  belongs_to :comment
end

describe Obfuscated do

  before do
    @post = Post.create(:name => "Sample")
    @comment = Comment.create(:post_id => @post.id)
  end

  it "has find_by_obfuscated_id method" do
    Post.respond_to?(:find_by_obfuscated_id).should == true
  end

  it "has a 12 digit hashed id" do
    @post.obfuscated_id.should be_a String
    @post.obfuscated_id.length.should == 12
  end

  it "overwrites to_param" do
    @post.to_param.should == @post.obfuscated_id
  end

  it "can be found with a hashed id" do
    Post.find_by_obfuscated_id( @post.obfuscated_id ).should == @post
  end

  it "can be found using the default find() method" do
    Post.find( @post.obfuscated_id ).should == @post
  end

  it "can be found using the default find() method and normal id" do
    Post.find( @post.id ).should == @post
  end

  it "can find using active relation" do
    Post.includes(:comments).find_by_obfuscated_id( @post.obfuscated_id ).should == @post
  end

end