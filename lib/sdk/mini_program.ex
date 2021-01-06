defmodule WeChat.SDK.MiniProgram do
  @moduledoc "小程序"
  alias WeChat.SDK

  @doc_link "https://developers.weixin.qq.com/miniprogram/dev"

  @doc """
  服务端获取开放数据 - [Official API Docs Link](#{@doc_link}/framework/open-ability/signature.html)

  [小程序登录](#{@doc_link}/framework/open-ability/login.html)
  """
  @spec decode_user_info(
          session_key :: String.t(),
          raw_data :: String.t(),
          signature :: String.t()
        ) :: {:ok, map()} | {:error, String.t()}
  def decode_user_info(session_key, raw_data, signature) do
    :crypto.hash(:sha, raw_data <> session_key)
    |> Base.encode16(case: :lower)
    |> case do
      ^signature ->
        Jason.decode(raw_data)

      _ ->
        {:error, "invalid"}
    end
  end

  @doc """
  服务端获取开放数据 - 包含敏感数据 - [Official API Docs Link](#{@doc_link}/framework/open-ability/signature.html)

  * [小程序登录](#{@doc_link}/framework/open-ability/login.html)
  * [加密数据解密算法](#{@doc_link}/framework/open-ability/signature.html#加密数据解密算法)
  """
  @spec decode_get_user_sensitive_info(
          session_key :: String.t(),
          encrypted_data :: String.t(),
          iv :: String.t()
        ) :: {:ok, map()} | :error | {:error, any()}
  def decode_get_user_sensitive_info(session_key, encrypted_data, iv) do
    with {:ok, session_key} <- Base.decode64(session_key),
         {:ok, iv} <- Base.decode64(iv),
         {:ok, encrypted_data} <- Base.decode64(encrypted_data) do
      :crypto.block_decrypt(:aes_cbc, session_key, iv, encrypted_data)
      |> decode_padding_with_pkcs7()
      |> Jason.decode()
    end
  end

  @doc """
  小程序登录

  API Docs:
    * [link](#{@doc_link}/api/open-api/login/wx.login.html){:target="_blank"}
  """
  @spec code2session(SDK.client(), code :: String.t()) :: SDK.response()
  def code2session(client, code) do
    appid = client.appid()
    {adapter_storage, args} = Keyword.fetch!(client.default_opts(), :adapter_storage)

    client.request(
      :get,
      url: "/sns/jscode2session",
      query: [
        appid: appid,
        secret: adapter_storage.secret_key(appid, args),
        grant_type: "authorization_code",
        js_code: code
      ]
    )
  end

  defp decode_padding_with_pkcs7(data) do
    data_size = byte_size(data)
    <<pad::8>> = binary_part(data, data_size, -1)
    binary_part(data, 0, data_size - pad)
  end
end
