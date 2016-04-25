# Cart

Cart is a generic shopping cart OTP-application that allows you to manage carts and their items.

### Features
* Standalone: Just run it on a node anywhere in your Erlang network
* Add / Remove / Update Items encoded as Elixir maps

### Prerequisites
* A running Postgresql server

### Installation

Check out the git repo

```
git checkout https://github.com/faber-lotto/cart.git
```

Add a config file for your desired environment. You only need to configure the ecto repo. For example in development:

```
# config/dev.exs
use Mix.Config

config :cart, Cart.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "cart_dev",
  hostname: "localhost",
  timeout: 5000
```

Get the dependencies and set up the database 

```
mix deps.get
mix ecto.create
mix ecto.migrate
```

### Run it

In production you would use exrm to create a build and run the executable on your node. In development you could run

```
iex --name mycart -S mix
```

Then open a console on any other node in your erlang network

```
iex --name cartclient
```

Now you can communicate with the server. My node running the cart server is called `ubuntu-14.04-amd64-vbox`. 

```
GenServer.call({Cart.CartServer, mycart@ubuntu-14.04-amd64-vbox}, {:add_item, %{"name" => "foo"}}
```

To see the complete functionality take a look at `test/cart_server_test.exs` ;).

### Call Cart from your own mix project

Instead of using the GenServer calls add [cart_client](https://github.com/faber-lotto/cart_client.git) to your deps and use its functions.
