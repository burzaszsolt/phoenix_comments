// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// Bring in Phoenix channels client library:
import {Socket} from "phoenix"

// And connect to the path in "lib/phoenix_comments_web/endpoint.ex". We pass the
// token for authentication. Read below how it should be used.
let socket = new Socket("/socket", {params: {token: window.userToken}})

// When you connect, you'll often need to authenticate the client.
// For example, imagine you have an authentication plug, `MyAuth`,
// which authenticates the session and assigns a `:current_user`.
// If the current user exists you can assign the user's token in
// the connection for use in the layout.
//
// In your "lib/phoenix_comments_web/router.ex":
//
//     pipeline :browser do
//       ...
//       plug MyAuth
//       plug :put_user_token
//     end
//
//     defp put_user_token(conn, _) do
//       if current_user = conn.assigns[:current_user] do
//         token = Phoenix.Token.sign(conn, "user socket", current_user.id)
//         assign(conn, :user_token, token)
//       else
//         conn
//       end
//     end
//
// Now you need to pass this token to JavaScript. You can do so
// inside a script tag in "lib/phoenix_comments_web/templates/layout/app.html.heex":
//
//     <script>window.userToken = "<%= assigns[:user_token] %>";</script>
//
// You will need to verify the user token in the "connect/3" function
// in "lib/phoenix_comments_web/channels/user_socket.ex":
//
//     def connect(%{"token" => token}, socket, _connect_info) do
//       # max_age: 1209600 is equivalent to two weeks in seconds
//       case Phoenix.Token.verify(socket, "user socket", token, max_age: 1_209_600) do
//         {:ok, user_id} ->
//           {:ok, assign(socket, :user, user_id)}
//
//         {:error, reason} ->
//           :error
//       end
//     end
//
// Finally, connect to the socket:
socket.connect()

const createSocket = () => {
  let channel = socket.channel(`comments:list`, {});
  console.log("channel", channel);
  channel
    .join()
    .receive("ok", (resp) => {
      console.log(resp);
      renderComments(resp.comments);
    })
    .receive("error", (resp) => {
      console.log("Unable to join", resp);
    });

  document.getElementById("add-comment-btn").addEventListener("click", () => {
    const content = document.querySelector("textarea").value;

    channel.push("comment:add", { content: content });
  });

  channel.on(`comments:new`, renderComment);
};

const renderComment = (event) => {
  console.log({ event });
  document.querySelector(".comment-list").innerHTML += commentTemplate(
    event.comment
  );
};

const renderComments = (comments) => {
  const renderedComments = comments.map((comment) => {
    return commentTemplate(comment);
  });

  document.querySelector(".comment-list").innerHTML = renderedComments.join("");
};

const commentTemplate = (comment) => {
  let name = "Anonymous";
  if (comment.user) {
    name = comment.user.name;
  }
  return `<li class="flex justify-between gap-x-6 py-5 border-md border-sky-400">${comment.content}<div>${name}</div></li>`;
};

window.createSocket = createSocket;
