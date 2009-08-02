$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require File.join(File.dirname(__FILE__), 'approximate_color_matching')

Spec::Runner.configure do |config|
  config.include(BeApproximatelyTheSameColorAsMatcher)
end

require 'compass-colors'

describe "sass extensions" do
  it "should lighten red into pink" do
    pink = invoke(:lighten, color(255,0,0), number(50))
    pink.to_s.should == "#ff8080"
  end

  it "should darken red into maroon" do
    maroon = invoke(:darken, color(255,0,0), number(50))
    maroon.to_s.should == "maroon"
  end

  it "should darken this blue into darker blue and then lighten it back again" do
    darker = invoke(:darken, color(0x4D, 0xA3, 0x78), number(50))
    lighter_again = invoke(:lighten, darker, number(100))
    color(0x4D, 0xA3, 0x78).should be_approximately_the_same_color_as(lighter_again)
  end

  it "shouldn't saturate fully saturated colors" do
    saturated = invoke(:saturate, color(0, 127, 127), number(50))
    saturated.should be_approximately_the_same_color_as(color(0, 127, 127))
  end

  def invoke(name, *args)
    Sass::Script::Functions::EvaluationContext.new({}).send(name, *args)
  end

  def color(r,g,b)
    Sass::Script::Color.new([r,g,b])
  end

  def number(num)
    Sass::Script::Number.new(num)
  end
end
