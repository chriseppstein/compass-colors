require 'sass'

module Sass::Script::Functions
  module Colors
    extend self
    def rgb_value(color)
      if color.respond_to?(:rgb)
        color.rgb
      else
        color.value
      end
    end
  end

  # Takes a color object and percent by which to lighten it (0 to 100).
  def lighten_percent(color, amount)
    Compass::Util.compass_warn("lighten-percent() is deprecated. Please use the scale-color() function provided by sass.")
    if unitless(amount).to_bool
      Compass::Util.compass_warn("Sass's scale-color() function requires a percent instead of a unitless number for the amount.")
      amount = Sass::Script::Number.new(amount.value, ['%'], [])
    end
    scale_color(color, "lightness" => amount)
  end

  # Takes a color object and percent by which to darken it (0 to 100).
  def darken_percent(color, amount)
    Compass::Util.compass_warn("darken-percent() is deprecated. Please use the scale-color() function provided by sass.")
    if unitless(amount).to_bool
      Compass::Util.compass_warn("Sass's scale-color() function requires a percent instead of a unitless number for the amount.")
      amount = Sass::Script::Number.new(-amount.value, ['%'], [])
    else
      amount = amount.times(Sass::Script::Number.new(-1))
    end
    scale_color(color, "lightness" => amount)
  end

  # Saturate (make a color "richer") a color by the given percent (0 to 100)
  def saturate_percent(color, amount)
    Compass::Util.compass_warn("saturate-percent() is deprecated. Please use the scale-color() function provided by sass.")
    if unitless(amount).to_bool
      Compass::Util.compass_warn("Sass's scale-color() function requires a percent instead of a unitless number for the amount.")
      amount = Sass::Script::Number.new(amount.value, ['%'], [])
    end
    scale_color(color, "saturation" => amount)
  end

  # Desaturate (make a color "grayer") a color by the given percent (0 to 100)
  def desaturate_percent(color, amount)
    Compass::Util.compass_warn("desaturate-percent() is deprecated. Please use the scale-color() function provided by sass.")
    if unitless(amount).to_bool
      Compass::Util.compass_warn("Sass's scale-color() function requires a percent instead of a unitless number for the amount.")
      amount = Sass::Script::Number.new(-amount.value, ['%'], [])
    else
      amount = amount.times(Sass::Script::Number.new(-1))
    end
    scale_color(color, "saturation" => amount)
  end

  # Return the luminosity of a color as a number between 0 and 100
  def luminosity(color)
    Compass::Util.compass_warn("luminosity($color) is deprecated. Please use the lightness($color) provided by sass.")
    lightness(color)
  end

end
