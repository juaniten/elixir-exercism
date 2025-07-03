defmodule LogParser do
  def valid_line?(line) do
    line =~ ~r/^\[(DEBUG|INFO|WARNING|ERROR)\]/
  end

  def split_line(line) do
    separator = ~r/<[~*\-=]*>/
    String.split(line, separator)
  end

  def remove_artifacts(line) do
    artifact = ~r/end-of-line\d+/i
    String.replace(line, artifact, "")
  end

  def tag_with_user_name(line) do
    case Regex.run(~r/User\s+(\S+)/, line) do
      [_, username] -> "[USER] #{username} #{line}"
      _ -> line
    end
  end
end
