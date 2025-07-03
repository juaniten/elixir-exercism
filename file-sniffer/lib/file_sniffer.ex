defmodule FileSniffer do

  @extensions_mimetypes %{
    "exe" => "application/octet-stream",
    "bmp" => "image/bmp",
    "png" => "image/png",
    "jpg" => "image/jpg",
    "gif" => "image/gif"
  }

  @signatures [
    {"application/octet-stream", <<0x7F, 0x45, 0x4C, 0x46>>},
    {"image/bmp", <<0x42, 0x4D>>},
    {"image/png", <<0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A>>},
    {"image/jpg", <<0xFF, 0xD8, 0xFF>>},
    {"image/gif", <<0x47, 0x49, 0x46>>}
  ]

  def type_from_extension(extension), do: @extensions_mimetypes[extension]

  def type_from_binary(file_binary) when not is_binary(file_binary), do: nil
  def type_from_binary(file_binary) do
    Enum.find_value(@signatures, fn {mimetype, signature} ->
      signature_length = byte_size(signature)
      if byte_size(file_binary) >= signature_length do
        <<initial::binary-size(signature_length), _::binary>> = file_binary
        if initial == signature, do: mimetype, else: nil
      else
        nil
      end
    end)
  end

  def verify(file_binary, extension) do
    file_type = type_from_binary(file_binary)
    expected_type = type_from_extension(extension)
    if file_type && file_type == expected_type do
      {:ok, expected_type}
    else
      {:error, "Warning, file format and file extension do not match."}
    end
  end
end
