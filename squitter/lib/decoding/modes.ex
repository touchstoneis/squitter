defmodule Squitter.Decoding.ModeS do
  @on_load :load_nifs

  require Logger
  use Bitwise, only_operators: true
  import Squitter.Decoding.Utils

  def load_nifs do
    :erlang.load_nif('./priv/modes', 0)
  end

  def checksum(_msg, _bits) do
    raise "NIF checksum/2 not implemented"
  end

  def icao_address(<<df :: 5, _rest :: bits>> = msg, checksum) when df in [0, 4, 5, 16, 20, 21, 24] do
    parity = binary_part(msg, byte_size(msg), -3)
    <<check_bytes :: 3-bytes>> = <<checksum :: 24>>
    Enum.zip(btol(check_bytes), btol(parity))
    |> Enum.map(fn({c, p}) -> c ^^^ p end)
    |> to_hex_string
  end

  def icao_address(<<df :: 5, _ :: 3, icao :: 3-bytes, _rest :: binary>>, _checksum) when df in [11, 17, 18] do
    to_hex_string(icao)
  end

  def icao_address(<<df :: 5, _rest :: bits>> = msg, _checksum) do
    Logger.warn "Failed to assign ICAO address for downlink format #{df}: #{inspect msg}"
    ""
  end
end