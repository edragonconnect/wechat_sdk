defmodule WeChat.SDK.Message do
  @moduledoc """
  消息管理

  [API Docs Link](https://developers.weixin.qq.com/doc/offiaccount/Message_Management/Service_Center_messages.html){:target="_blank"}
  """
  import Jason.Helpers
  alias WeChat.SDK
  alias WeChat.SDK.{Card, Material}

  @doc_link "https://developers.weixin.qq.com/doc/offiaccount/Message_Management/Service_Center_messages.html"

  @type template_id :: String.t
  @type title :: String.t
  @type description :: String.t
  @type url :: String.t
  @type pic_url :: String.t

  @doc """
  获取模板列表

  ## API Docs
    [link](#{@doc_link}#3){:target="_blank"}
  """
  @spec get_all_private_template(SDK.client) :: SDK.response
  def get_all_private_template(client) do
    client.request(:get, url: "/cgi-bin/message/template/get_all_private_template")
  end

  @doc """
  发送模板消息

  ## API Docs
    [link](#{@doc_link}#5){:target="_blank"}
  """
  @spec send_template_message(SDK.client, SDK.openid, template_id, data :: map) :: SDK.response
  def send_template_message(client, openid, template_id, data) do
    client.request(
      :post,
      url: "/cgi-bin/message/template/send",
      body: json_map(
        touser: openid,
        template_id: template_id,
        data: data
      )
    )
  end
  @spec send_template_message(SDK.client, body :: map) :: SDK.response
  def send_template_message(client, body) do
    client.request(
      :post,
      url: "/cgi-bin/message/template/send",
      body: body
    )
  end

  @doc """
  客服接口-发消息

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_custom_message_text(SDK.client, SDK.openid, content :: String.t) :: SDK.response
  def send_custom_message_text(client, openid, content) do
    client.request(
      :post,
      url: "/cgi-bin/message/custom/send",
      body: json_map(
        touser: openid,
        msgtype: "text",
        text: %{
          content: content
        }
      )
    )
  end

  @doc """
  客服接口-发图文消息(点击跳转到外链)

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_custom_message_news(SDK.client, SDK.openid, title, description, url, pic_url) :: SDK.response
  def send_custom_message_news(client, openid, title, description, url, pic_url) do
    send_custom_message(
      client,
      json_map(
        touser: openid,
        msgtype: "news",
        news: %{
          articles: [
            %{title: title, description: description, url: url, picurl: pic_url}
          ]
        }
      )
    )
  end

  @doc """
  客服接口-发图文消息(点击跳转到图文消息页面)

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_custom_message_mp_news(SDK.client, SDK.openid, Material.media_id) :: SDK.response
  def send_custom_message_mp_news(client, openid, media_id) do
    send_custom_message(
      client,
      json_map(
        touser: openid,
        msgtype: "mpnews",
        mpnews: %{
          media_id: media_id
        }
      )
    )
  end

  @doc """
  客服接口-发送卡券

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_custom_message_card(SDK.client, SDK.openid, Card.card_id) :: SDK.response
  def send_custom_message_card(client, openid, card_id) do
    send_custom_message(
      client,
      json_map(
        touser: openid,
        msgtype: "wxcard",
        wxcard: %{
          card_id: card_id
        }
      )
    )
  end

  @doc """
  客服接口

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  def send_custom_message(client, body) do
    client.request(:post, url: "/cgi-bin/message/custom/send", body: body)
  end

  @doc """
  客服输入状态

  开发者可通过调用“客服输入状态”接口，返回客服当前输入状态给用户.

  ## API Docs
    [link](#{@doc_link}#8){:target="_blank"}
  """
  @spec typing(SDK.client, SDK.openid, is_typing :: boolean) :: SDK.response
  def typing(client, openid, is_typing \\ true) do
    command = if(is_typing, do: "Typing", else: "CancelTyping")
    client.request(
      :post,
      url: "/cgi-bin/message/custom/typing",
      body: json_map(
        touser: openid,
        command: command
      )
    )
  end
end
