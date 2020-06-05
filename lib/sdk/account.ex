defmodule WeChat.SDK.Account do
  @moduledoc "账号管理"
  import Jason.Helpers
  alias WeChat.SDK

  @typedoc """
  二维码类型
    * `QR_SCENE`            为临时的整型参数值
    * `QR_STR_SCENE`        为临时的字符串参数值
    * `QR_LIMIT_SCENE`      为永久的整型参数值
    * `QR_LIMIT_STR_SCENE`  为永久的字符串参数值
  """
  @type qrcode_action_name :: String.t

  @doc """
  生成二维码

  ## 二维码类型(action_name)
    * `QR_SCENE`            为临时的整型参数值
    * `QR_STR_SCENE`        为临时的字符串参数值
    * `QR_LIMIT_SCENE`      为永久的整型参数值
    * `QR_LIMIT_STR_SCENE`  为永久的字符串参数值

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/Account_Management/Generating_a_Parametric_QR_Code.html){:target="_blank"}
  """
  @spec create_qrcode(SDK.client, scene_id :: String.t, qrcode_action_name, expire_seconds :: integer) :: SDK.response
  def create_qrcode(client, scene_id, action_name \\ "QR_LIMIT_SCENE", expire_seconds \\ 1800) when action_name in [
    "QR_SCENE",
    "QR_STR_SCENE",
    "QR_LIMIT_SCENE",
    "QR_LIMIT_STR_SCENE"
  ] do
    scene_key = action_name in ["QR_STR_SCENE", "QR_LIMIT_STR_SCENE"] && :scene_str || :scene_id
    client.request(
      :get,
      url: "/cgi-bin/qrcode/create",
      body: json_map(
        action_name: action_name,
        expire_seconds: expire_seconds,
        action_info: %{
          scene: %{
            scene_key => scene_id
          }
        }
      )
    )
  end

  @doc """
  长链接转成短链接

  ## API Docs
    [link](https://developers.weixin.qq.com/doc/offiaccount/Account_Management/URL_Shortener.html){:target="_blank"}
  """
  @spec short_url(SDK.client, long_url :: String.t) :: SDK.response
  def short_url(client, long_url) do
    client.request(
      :get,
      url: "/cgi-bin/shorturl",
      body: json_map(
        action: "long2short",
        long_url: long_url
      )
    )
  end
end
