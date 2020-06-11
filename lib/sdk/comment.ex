defmodule WeChat.SDK.Comment do
  @moduledoc """
  图文消息留言管理

  [API Docs Link](https://developers.weixin.qq.com/doc/offiaccount/Comments_management/Image_Comments_Management_Interface.html){:target="_blank"}
  """
  import Jason.Helpers
  alias WeChat.SDK

  @doc_link "#{SDK.doc_link_prefix()}/offiaccount/Comments_management/Image_Comments_Management_Interface.html"

  @type msg_data_id :: integer
  @type user_comment_id :: integer
  @typedoc """
  评论类型
    * `0` - 普通评论&精选评论
    * `1` - 普通评论
    * `2` - 精选评论
  """
  @type comment_type :: 0 | 1 | 2
  @type content :: String.t()

  @doc """
  打开已群发文章评论

  ## API Docs
    [link](#{@doc_link}){:target="_blank"}
  """
  @spec open(SDK.client(), msg_data_id, index :: integer) :: SDK.response()
  def open(client, msg_data_id, index \\ 0) do
    client.request(
      :post,
      url: "/cgi-bin/comment/open",
      body: json_map(msg_data_id: msg_data_id, index: index)
    )
  end

  @doc """
  关闭已群发文章评论

  ## API Docs
    [link](#{@doc_link}){:target="_blank"}
  """
  @spec close(SDK.client(), msg_data_id, index :: integer) :: SDK.response()
  def close(client, msg_data_id, index \\ 0) do
    client.request(
      :post,
      url: "/cgi-bin/comment/close",
      body: json_map(msg_data_id: msg_data_id, index: index)
    )
  end

  @doc """
  查看指定文章的评论数据

  ## API Docs
    [link](#{@doc_link}){:target="_blank"}
    
  ## 参数说明
  | 参数 | 是否必须 | 类型 | 说明 |
  | -- | ------- | --- | --- |
  | msg_data_id | 是 | Uint32 | 群发返回的msg_data_id |
  | index | 否 | Uint32 | 多图文时，用来指定第几篇图文，从0开始，不带默认返回该msg_data_id的第一篇图文 |
  | begin | 是 | Uint32 | 起始位置 |
  | count | 是 | Uint32 | 获取数目（>=50会被拒绝） |
  | type | 是 | Uint32 | type=0 普通评论&精选评论 type=1 普通评论 type=2 精选评论 |
  """
  @spec list(
          SDK.client(),
          msg_data_id,
          begin :: integer,
          count :: integer,
          comment_type,
          index :: integer
        ) :: SDK.response()
  def list(client, msg_data_id, begin, count, type, index \\ 0)
      when count <= 50 and type in 0..2 do
    client.request(
      :post,
      url: "/cgi-bin/comment/list",
      body:
        json_map(
          msg_data_id: msg_data_id,
          index: index,
          begin: begin,
          count: count,
          type: type
        )
    )
  end

  @doc """
  将评论标记精选

  ## API Docs
    [link](#{@doc_link}){:target="_blank"}
  """
  @spec mark_elect(SDK.client(), msg_data_id, user_comment_id, index :: integer) :: SDK.response()
  def mark_elect(client, msg_data_id, user_comment_id, index \\ 0) do
    client.request(
      :post,
      url: "/cgi-bin/comment/markelect",
      body:
        json_map(
          msg_data_id: msg_data_id,
          index: index,
          user_comment_id: user_comment_id
        )
    )
  end

  @doc """
  将评论取消精选

  ## API Docs
    [link](#{@doc_link}){:target="_blank"}
  """
  @spec unmark_elect(SDK.client(), msg_data_id, user_comment_id, index :: integer) ::
          SDK.response()
  def unmark_elect(client, msg_data_id, user_comment_id, index \\ 0) do
    client.request(
      :post,
      url: "/cgi-bin/comment/unmarkelect",
      body:
        json_map(
          msg_data_id: msg_data_id,
          index: index,
          user_comment_id: user_comment_id
        )
    )
  end

  @doc """
  删除评论

  ## API Docs
    [link](#{@doc_link}){:target="_blank"}
  """
  @spec delete(SDK.client(), msg_data_id, user_comment_id, index :: integer) :: SDK.response()
  def delete(client, msg_data_id, user_comment_id, index \\ 0) do
    client.request(
      :post,
      url: "/cgi-bin/comment/delete",
      body:
        json_map(
          msg_data_id: msg_data_id,
          index: index,
          user_comment_id: user_comment_id
        )
    )
  end

  @doc """
  回复评论

  ## API Docs
    [link](#{@doc_link}){:target="_blank"}
  """
  @spec add_reply(SDK.client(), msg_data_id, user_comment_id, content, index :: integer) ::
          SDK.response()
  def add_reply(client, msg_data_id, user_comment_id, content, index \\ 0) do
    client.request(
      :post,
      url: "/cgi-bin/comment/reply/add",
      body:
        json_map(
          msg_data_id: msg_data_id,
          index: index,
          user_comment_id: user_comment_id,
          content: content
        )
    )
  end

  @doc """
  删除回复

  ## API Docs
    [link](#{@doc_link}){:target="_blank"}
  """
  @spec delete_reply(SDK.client(), msg_data_id, user_comment_id, index :: integer) ::
          SDK.response()
  def delete_reply(client, msg_data_id, user_comment_id, index \\ 0) do
    client.request(
      :post,
      url: "/cgi-bin/comment/reply/delete",
      body:
        json_map(
          msg_data_id: msg_data_id,
          index: index,
          user_comment_id: user_comment_id
        )
    )
  end
end
