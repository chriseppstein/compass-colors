$:.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require File.join(File.dirname(__FILE__), 'approximate_color_matching')
require 'sass'
require 'stringio'

module Capturing
  def capture_stderr
    $stderr, real_stderr = StringIO.new, $stderr
    yield
    $stderr.string
  ensure
    $stderr = real_stderr
  end
end

Spec::Runner.configure do |config|
  config.include(BeApproximatelyTheSameColorAsMatcher)
  config.include(Capturing)
end

require 'compass-colors'

describe "sass extensions" do

  it "should deprecate luminosity" do
    warning = capture_stderr do
      invoke(:luminosity, color(255,0,0))
    end
    warning.strip.should == "luminosity($color) is deprecated. Please use the lightness($color) provided by sass."
  end

  it "should deprecate desaturate-percent" do
    warning = capture_stderr do
      desaturated = invoke(:desaturate_percent, color(255,0,0), number(25))
      desaturated.should be_approximately_the_same_color_as(color(223,32,32))
    end
    warning.should == %q<desaturate-percent() is deprecated. Please use the scale-color() function provided by sass.
Sass's scale-color() function requires a percent instead of a unitless number for the amount.
>
  end

  it "should deprecate saturate-percent" do
    warning = capture_stderr do
      desaturated = invoke(:saturate_percent, color(127,32,32), number(25))
      desaturated.should be_approximately_the_same_color_as(color(135,24,24))
    end
    warning.should == %q<saturate-percent() is deprecated. Please use the scale-color() function provided by sass.
Sass's scale-color() function requires a percent instead of a unitless number for the amount.
>
  end

  it "should desaturate-percents" do
    capture_stderr do
      desaturated = invoke(:desaturate_percent, color(255,0,0), number(25, '%'))
      desaturated.should be_approximately_the_same_color_as(color(223,32,32))
    end
  end

  it "should saturate colors" do
    color = invoke(:saturate, color(127,32,32), number(25))
    color.should be_approximately_the_same_color_as(color(147,12,12))
  end

  it "should desaturate colors" do
    color = invoke(:desaturate, color(255,0,0), number(25))
    color.should be_approximately_the_same_color_as(color(223,32,32))
  end

  it "should lighten red into pink" do
    pink = invoke(:lighten, color(255,0,0), number(25))
    pink.should be_approximately_the_same_color_as(color(255,127,127))
  end

  it "should lighten red into pink (percentage)" do
    warning = capture_stderr do
      pink = invoke(:lighten_percent, color(255,0,0), number(50))
      pink.should be_approximately_the_same_color_as(color(255,127,127))
    end
    warning.should == "lighten-percent() is deprecated. Please use the scale-color() function provided by sass.\nSass's scale-color() function requires a percent instead of a unitless number for the amount.\n"
  end

  it "should darken red into maroon" do
    maroon = invoke(:darken, color(255,0,0), number(25))
    maroon.should be_approximately_the_same_color_as(color(127,0,0))
  end

  it "should darken red into maroon (percentage)" do
    warning = capture_stderr do
      maroon = invoke(:darken_percent, color(255,0,0), number(50))
      maroon.should be_approximately_the_same_color_as(color(127,0,0))
    end
    warning.should == "darken-percent() is deprecated. Please use the scale-color() function provided by sass.\nSass's scale-color() function requires a percent instead of a unitless number for the amount.\n"
  end

  it "should darken white into gray and back again" do
    darker = invoke(:darken, color(0xff, 0xff, 0xff), number(50))
    lighter_again = invoke(:lighten, darker, number(100))
    color(0xff, 0xff, 0xff).should be_approximately_the_same_color_as(lighter_again)
  end

  it "shouldn't saturate fully saturated colors" do
    saturated = invoke(:saturate, color(0, 127, 127), number(50))
    saturated.should be_approximately_the_same_color_as(color(0, 127, 127))
  end

  it "should mix colors" do
    mixed = invoke(:mix, color(127, 127, 0), color(0, 127, 127), number(50))
    mixed.should be_approximately_the_same_color_as(color(63, 127, 63))
  end

  it "should adjust hues" do
    mixed = invoke(:adjust_hue, color(127, 0, 0), number(120, "deg"))
    mixed.should be_approximately_the_same_color_as(color(0, 127, 0))
  end

  def invoke(name, *args)
    Sass::Script::Functions::EvaluationContext.new({}).send(name, *args)
  end

  def color(r,g,b)
    Sass::Script::Color.new([r,g,b])
  end

  def number(num, units = nil)
    Sass::Script::Number.new(num, Array(units))
  end
end
