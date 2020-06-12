defmodule WeChat.SDK.BatchSends do
  @moduledoc """
  消息管理 - 群发接口和原创效验

  [API Docs Link](https://developers.weixin.qq.com/doc/offiaccount/Message_Management/Batch_Sends_and_Originality_Checks.html){:target="_blank"}
  """
  import Jason.Helpers
  alias WeChat.SDK

  @doc_link "#{SDK.doc_link_prefix()}/offiaccount/Message_Management/Batch_Sends_and_Originality_Checks.html"

  @typedoc "消息发送任务的ID"
  @type msg_id :: String.t()

  @doc """
  根据标签进行群发【订阅号与服务号认证后均可用】

  ## API Docs
    [link](#{@doc_link}#2){:target="_blank"}
  """
  @spec batch_send_by_tag(SDK.client(), body :: map) :: SDK.response()
  def batch_send_by_tag(client, body) do
    client.request(:post, url: "/cgi-bin/message/mass/sendall", body: body)
  end

  @doc """
  根据OpenID列表群发【订阅号不可用，服务号认证后可用】

  ## API Docs
    [link](#{@doc_link}#3){:target="_blank"}
  """
  @spec batch_send_by_list(SDK.client(), body :: map) :: SDK.response()
  def batch_send_by_list(client, body) do
    client.request(:post, url: "/cgi-bin/message/mass/send", body: body)
  end

  @doc """
  删除群发【订阅号与服务号认证后均可用】

  群发之后，随时可以通过该接口删除群发。

  ## 请注意

  1. 只有已经发送成功的消息才能删除
  2. 删除消息是将消息的图文详情页失效，已经收到的用户，还是能在其本地看到消息卡片。
  3. 删除群发消息只能删除图文消息和视频消息，其他类型的消息一经发送，无法删除。
  4. 如果多次群发发送的是一个图文消息，那么删除其中一次群发，就会删除掉这个图文消息也，导致所有群发都失效

  ## API Docs
    [link](#{@doc_link}#4){:target="_blank"}
  """
  @spec delete(SDK.client(), msg_id, article_idx :: integer) :: SDK.response()
  def delete(client, msg_id, article_idx \\ 0) do
    client.request(:post,
      url: "/cgi-bin/message/mass/delete",
      body: json_map(msg_id: msg_id, article_idx: article_idx)
    )
  end

  @doc """
  预览接口【订阅号与服务号认证后均可用】

  开发者可通过该接口发送消息给指定用户，在手机端查看消息的样式和排版。为了满足第三方平台开发者的需求，在保留对openID预览能力的同时，增加了对指定微信号发送预览的能力，但该能力每日调用次数有限制（100次），请勿滥用。

  ## API Docs
    [link](#{@doc_link}#5){:target="_blank"}
  """
  @spec preview(SDK.client(), body :: map) :: SDK.response()
  def preview(client, body) do
    client.request(:post, url: "/cgi-bin/message/mass/preview", body: body)
  end

  @doc """
  查询群发消息发送状态【订阅号与服务号认证后均可用】

  开发者可通过该接口发送消息给指定用户，在手机端查看消息的样式和排版。为了满足第三方平台开发者的需求，在保留对openID预览能力的同时，增加了对指定微信号发送预览的能力，但该能力每日调用次数有限制（100次），请勿滥用。

  ## API Docs
    [link](#{@doc_link}#5){:target="_blank"}
  """
  @spec get(SDK.client(), msg_id) :: SDK.response()
  def get(client, msg_id) do
    client.request(:post, url: "/cgi-bin/message/mass/get", body: json_map(msg_id: msg_id))
  end

  @doc """
  群发速度 - 获取

  ## API Docs
    [link](#{@doc_link}#9){:target="_blank"}
  """
  @spec get_speed(SDK.client()) :: SDK.response()
  def get_speed(client) do
    client.request(:get, url: "/cgi-bin/message/mass/speed/get")
  end

  @doc """
  群发速度 - 设置

  群发速度的级别，是一个0到4的整数，数字越大表示群发速度越慢。

  speed 与 realspeed 的关系如下：

  | speed | realspeed |
  | ----- | --------- |
  | 0 | 80w/分钟 |
  | 1 | 60w/分钟 |
  | 2 | 45w/分钟 |
  | 3 | 30w/分钟 |
  | 4 | 10w/分钟 |

  ## API Docs
    [link](#{@doc_link}#9){:target="_blank"}
  """
  @spec set_speed(SDK.client(), speed :: integer) :: SDK.response()
  def set_speed(client, speed) do
    client.request(:post, url: "/cgi-bin/message/mass/speed/set", body: json_map(speed: speed))
  end
end
