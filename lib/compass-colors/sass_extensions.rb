require 'sass'

module Sass::Script::Functions
  # Takes a color object and amount by which to lighten it (0 to 100).
  def lighten(color, amount)
    hsl = Compass::Colors::HSL.from_color(color)
    if percentage?(amount)
      hsl.l += (1 - hsl.l) * (amount.value / 100.0)
    else
      hsl.l += amount.value
    end
    hsl.to_color
  end

  # Takes a color object and amount by which to darken it (0 to 100).
  def darken(color, amount)
    hsl = Compass::Colors::HSL.from_color(color)
    if percentage?(amount)
      hsl.l *= 1.0 - (amount.value / 100.0)
    else
      hsl.l -= amount.value
    end
    hsl.to_color
  end

  # Saturate (make a color "richer") a color by the given amount (0 to 100)
  def saturate(color, amount)
    hsl = Compass::Colors::HSL.from_color(color)
    if percentage?(amount)
      hsl.s += (1 - hsl.s) * (amount.value / 100.0)
    else
      hsl.s += amount.value
    end
    hsl.to_color
  end

  # Desaturate (make a color "grayer") a color by the given amount (0 to 100)
  def desaturate(color, amount)
    hsl = Compass::Colors::HSL.from_color(color)
    if percentage?(amount)
      hsl.s *= (1.0 - (amount.value / 100.0))
    else
      hsl.s -= amount.value
    end
    hsl.to_color
  end

  # Return the hue of a color as a number between 0 and 360
  def hue(color)
    Sass::Script::Number.new(Compass::Colors::HSL.from_color(color).h.round)
  end

  # Return the saturation of a color as a number between 0 and 100
  def saturation(color)
    Sass::Script::Number.new((Compass::Colors::HSL.from_color(color).s * 100).round)
  end

  # Return the luminosity of a color as a number between 0 and 100
  def luminosity(color)
    Sass::Script::Number.new((Compass::Colors::HSL.from_color(color).l * 100).round)
  end

  # Mixes two colors by some amount (0 to 100). Defaults to 50.
  def mix(color1, color2, amount = nil)
    percent = amount ? amount.value.round / 100.0 : 0.5
    new_colors = color1.rgb.zip(color2.rgb).map{|c1, c2| (c1 * percent) + (c2 * (1 - percent))}
    Sass::Script::Color.new(new_colors)
  end

  # Returns the grayscale equivalent color for the given color
  def grayscale(color)
    hsl = Compass::Colors::HSL.from_color(color)
    g = (hsl.l * 255).round
    Sass::Script::Color.new([g, g, g])
  end

  # adjust the hue of a color by the given number of degrees.
  def adjust_hue(color, degrees)
    hsl = Compass::Colors::HSL.from_color(color)
    degrees = degrees.value.to_f.round if degrees.is_a?(Sass::Script::Literal)
    hsl.h += degrees
    hsl.to_color
  end

  def complement(color)
    adjust_hue color, 180
  end

  private

  def percentage?(amount)
    amount.numerator_units == ["%"] || (amount.unitless? && amount.value > 1 && amount.value < 100)
  end

end
