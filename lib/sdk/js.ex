defmodule WeChat.SDK.JS do
  @moduledoc """
  JS-SDK

  [API Docs Link](https://developers.weixin.qq.com/doc/offiaccount/OA_Web_Apps/JS-SDK.html)
  """
  import Jason.Helpers
  alias WeChat.SDK

  @doc_link "#{SDK.doc_link_prefix()}/offiaccount/OA_Web_Apps/JS-SDK.html"

  @typedoc """
  JS API的临时票据类型
    * `"jsapi"` - JS-SDK Config
    * `"wx_card"` - 微信卡券
  """
  @type js_api_ticket_type :: String.t()

  @doc """
  JS-SDK配置

  ## API Docs
    [link](#{@doc_link}#4)
  """
  @spec js_sdk_config(SDK.client(), url :: String.t()) :: SDK.response()
  def js_sdk_config(client, url) do
    case js_api_ticket(client, "jsapi") do
      {:ok, 200, %{"errcode" => 0, "ticket" => ticket}} ->
        info = WeChat.sign_jssdk(ticket, url)

        %{
          appid: client.appid(),
          timestamp: info.timestamp,
          nonceStr: info.noncestr,
          signature: info.value
        }

      _ ->
        %{}
    end
  end

  @doc """
  微信卡券配置 - 添加卡券

  ## API Docs
    [link](#{@doc_link}#53)
  """
  def add_card_config(client, card_id, outer_str) do
    case js_api_ticket(client, "wx_card") do
      {:ok, 200, %{"errcode" => 0, "ticket" => ticket}} ->
        info = WeChat.sign_card(ticket, card_id)

        card_ext =
          json_map(
            appid: client.appid(),
            timestamp: info.timestamp,
            nonce_str: info.noncestr,
            signature: info.value,
            outer_str: outer_str
          )
          |> Jason.encode!()

        %{
          cardId: card_id,
          cardExt: card_ext
        }

      _ ->
        %{}
    end
  end

  @doc """
  微信卡券配置 - 添加卡券(绑定openid)

  ## API Docs
    [link](#{@doc_link}#53)
  """
  def add_card_config(client, card_id, outer_str, openid) do
    case js_api_ticket(client, "wx_card") do
      {:ok, 200, %{"errcode" => 0, "ticket" => ticket}} ->
        info = WeChat.sign_card(ticket, card_id, openid)

        card_ext =
          json_map(
            appid: client.appid(),
            timestamp: info.timestamp,
            nonce_str: info.noncestr,
            signature: info.value,
            outer_str: outer_str,
            openid: openid
          )
          |> Jason.encode!()

        %{
          cardId: card_id,
          cardExt: card_ext
        }

      _ ->
        %{}
    end
  end

  @doc """
  获取api_ticket

  ## API Docs
    [link](#{@doc_link}#62)
  """
  @spec js_api_ticket(SDK.client(), js_api_ticket_type) :: SDK.response()
  def js_api_ticket(client, type) do
    client.request(
      :get,
      url: "/cgi-bin/ticket/getticket",
      query: [
        type: type
      ]
    )
  end
end
