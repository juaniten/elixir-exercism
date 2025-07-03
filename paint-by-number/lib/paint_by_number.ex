defmodule PaintByNumber do
  def palette_bit_size(color_count) when color_count <= 2, do: 1
  def palette_bit_size(color_count), do: 1 + palette_bit_size(color_count / 2)

  def empty_picture(), do: <<>>

  def test_picture(), do: <<0b00::2, 0b01::2, 0b10::2, 0b11::2>>

  def prepend_pixel(picture, color_count, pixel_color_index) do
    bit_size = palette_bit_size(color_count)
    <<pixel_color_index::size(bit_size), picture::bitstring>>
  end

  def get_first_pixel(picture, _color_count) when picture == <<>>, do: nil
  def get_first_pixel(picture, color_count) do
    bit_size = palette_bit_size(color_count)
    <<first::size(bit_size), _::bitstring>> = picture
    first
  end

  def drop_first_pixel(picture, _color_count) when picture == <<>>, do: <<>>
  def drop_first_pixel(picture, color_count) do
    bit_size = palette_bit_size(color_count)
    <<_::size(bit_size), rest::bitstring>> = picture
    rest
  end

  def concat_pictures(picture1, picture2), do: <<picture1::bitstring, picture2::bitstring>>
end
