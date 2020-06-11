defmodule WeChat.SDK.CustomMessage do
  @moduledoc """
  消息管理 - 客服消息

  [API Docs Link](https://developers.weixin.qq.com/doc/offiaccount/Message_Management/Service_Center_messages.html){:target="_blank"}
  """
  import Jason.Helpers
  alias WeChat.SDK
  alias WeChat.SDK.{Card, Material}

  @doc_link "#{SDK.doc_link_prefix()}/offiaccount/Message_Management/Service_Center_messages.html"

  @type template_id :: String.t()
  @type title :: String.t()
  @type description :: String.t()
  @type url :: String.t()
  @type pic_url :: String.t()
  @type content :: String.t()

  @doc """
  客服消息接口-发送文本消息

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_text(SDK.client(), SDK.openid(), content) :: SDK.response()
  def send_text(client, openid, content) do
    send_msg(
      client,
      json_map(
        touser: openid,
        msgtype: "text",
        text: %{content: content}
      )
    )
  end

  @doc """
  客服消息接口-发送文本消息-by某个客服帐号

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_text(SDK.client(), SDK.openid(), content, SDK.CustomService.kf_account()) ::
          SDK.response()
  def send_text(client, openid, content, kf_account) do
    send_msg(
      client,
      json_map(
        touser: openid,
        msgtype: "text",
        text: %{content: content},
        customservice: %{kf_account: kf_account}
      )
    )
  end

  @doc """
  客服消息接口-发送图片消息

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_image(SDK.client(), SDK.openid(), SDK.Material.media_id()) :: SDK.response()
  def send_image(client, openid, media_id) do
    send_msg(
      client,
      json_map(
        touser: openid,
        msgtype: "image",
        image: %{media_id: media_id}
      )
    )
  end

  @doc """
  客服消息接口-发送语音消息

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_voice(SDK.client(), SDK.openid(), SDK.Material.media_id()) :: SDK.response()
  def send_voice(client, openid, media_id) do
    send_msg(
      client,
      json_map(
        touser: openid,
        msgtype: "voice",
        voice: %{media_id: media_id}
      )
    )
  end

  @doc """
  客服消息接口-发送视频消息

  ## Example

  ```elixir
  #{__MODULE__}.send_video(client, openid, {
    media_id:         "MEDIA_ID",
    thumb_media_id:   "MEDIA_ID",
    title:            "TITLE",
    description:      "DESCRIPTION"
  })
  ```

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_video(SDK.client(), SDK.openid(), map) :: SDK.response()
  def send_video(client, openid, map) do
    send_msg(
      client,
      json_map(
        touser: openid,
        msgtype: "video",
        video: map
      )
    )
  end

  @doc """
  客服消息接口-发送音乐消息

  ## Example

  ```elixir
  #{__MODULE__}.send_music(client, openid, {
    title:          "MUSIC_TITLE",
    description:    "MUSIC_DESCRIPTION",
    musicurl:       "MUSIC_URL",
    hqmusicurl:     "HQ_MUSIC_URL",
    thumb_media_id: "THUMB_MEDIA_ID"
  })
  ```

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_music(SDK.client(), SDK.openid(), map) :: SDK.response()
  def send_music(client, openid, map) do
    send_msg(
      client,
      json_map(
        touser: openid,
        msgtype: "music",
        music: map
      )
    )
  end

  @doc """
  客服消息接口-发送图文消息(点击跳转到外链)

  ## Example

  ```elixir
  #{__MODULE__}.send_news(client, openid, {
    title:        "Happy Day",
    description:  "Is Really A Happy Day",
    url:          "URL",
    picurl:       "PIC_URL"
  })
  ```

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_news(SDK.client(), SDK.openid(), title, description, url, pic_url) ::
          SDK.response()
  def send_news(client, openid, title, description, url, pic_url) do
    send_msg(
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
  客服消息接口-发送图文消息(点击跳转到外链)

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_news(SDK.client(), SDK.openid(), article :: map) :: SDK.response()
  def send_news(client, openid, article) do
    send_msg(
      client,
      json_map(
        touser: openid,
        msgtype: "news",
        news: %{
          articles: [article]
        }
      )
    )
  end

  @doc """
  客服消息接口-发送图文消息(点击跳转到图文消息页面)

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_mp_news(SDK.client(), SDK.openid(), Material.media_id()) :: SDK.response()
  def send_mp_news(client, openid, media_id) do
    send_msg(
      client,
      json_map(
        touser: openid,
        msgtype: "mpnews",
        mpnews: %{media_id: media_id}
      )
    )
  end

  @doc """
  客服消息接口-发送菜单消息

  ## Example

  ```elixir
  #{__MODULE__}.send_menu(client, openid, {
    head_content: "您对本次服务是否满意呢?",
    list: [
      {
        id: "101",
        content: "满意"
      },
      {
        id: "102",
        content: "不满意"
      }
    ],
    tail_content: "欢迎再次光临"
  })
  ```

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_menu(SDK.client(), SDK.openid(), map) :: SDK.response()
  def send_menu(client, openid, map) do
    send_msg(
      client,
      json_map(
        touser: openid,
        msgtype: "msgmenu",
        msgmenu: map
      )
    )
  end

  @doc """
  客服消息接口-发送卡券

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_card(SDK.client(), SDK.openid(), Card.card_id()) :: SDK.response()
  def send_card(client, openid, card_id) do
    send_msg(
      client,
      json_map(
        touser: openid,
        msgtype: "wxcard",
        wxcard: %{card_id: card_id}
      )
    )
  end

  @doc """
  客服消息接口-发送小程序卡片（要求小程序与公众号已关联）

  ## Example
  ```elixir
  #{__MODULE__}.send_mini_program_page(client, openid, {
    title:    "title",
    appid:    "appid",
    pagepath: "pagepath",
    thumb_media_id: "thumb_media_id"
  })
  ```

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  @spec send_mini_program_page(SDK.client(), SDK.openid(), map) :: SDK.response()
  def send_mini_program_page(client, openid, map) do
    send_msg(
      client,
      json_map(
        touser: openid,
        msgtype: "miniprogrampage",
        miniprogrampage: map
      )
    )
  end

  @doc """
  客服消息接口

  ## API Docs
    [link](#{@doc_link}#7){:target="_blank"}
  """
  def send_msg(client, body) do
    client.request(:post, url: "/cgi-bin/message/custom/send", body: body)
  end

  @doc """
  客服输入状态

  开发者可通过调用“客服输入状态”接口，返回客服当前输入状态给用户.

  ## API Docs
    [link](#{@doc_link}#8){:target="_blank"}
  """
  @spec typing(SDK.client(), SDK.openid(), is_typing :: boolean) :: SDK.response()
  def typing(client, openid, is_typing \\ true) do
    command = if(is_typing, do: "Typing", else: "CancelTyping")

    client.request(
      :post,
      url: "/cgi-bin/message/custom/typing",
      body: json_map(touser: openid, command: command)
    )
  end
end
