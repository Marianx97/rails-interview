todo_list_1 = TodoList.create(name: 'Setup Rails Application')
Item.create(
  name: 'Install Rails Gem',
  description: 'Use gem command to install the latest version of Ruby on Rails framework.',
  todo_list: todo_list_1
)
Item.create(
  name: 'Generate New Rails App',
  description: 'Use the rails new command followed by the desired application name to generate a new Rails application.',
  todo_list: todo_list_1
)
Item.create(
  name: 'Setup Database Configuration',
  description: 'Configure the config/database.yml file to specify the database connection details for development, test, and production environments.',
  todo_list: todo_list_1
)

todo_list_2 = TodoList.create(name: 'Setup Docker PG database')
Item.create(
  name: 'Install Docker',
  description: 'Download and install Docker on your system.',
  todo_list: todo_list_2
)
Item.create(
  name: 'Pull PostgreSQL image',
  description: 'Pull the official PostgreSQL Docker image from Docker Hub.',
  todo_list: todo_list_2
)
Item.create(
  name: 'Run PostgreSQL container',
  description: 'Create and run a Docker container for PostgreSQL using the pulled image.',
  todo_list: todo_list_2
)

todo_list_3 = TodoList.create(name: 'Create todo_lists table')
Item.create(
  name: 'Generate migration file',
  description: 'Run the Rails generator to create a migration file for the todo_lists table.',
  todo_list: todo_list_3
)
Item.create(
  name: 'Define table structure',
  description: 'Write the migration file to define the structure of the todo_lists table.',
  todo_list: todo_list_3
)
Item.create(
  name: 'Run migration',
  description: 'Execute the migration file to create the todo_lists table in the database.',
  todo_list: todo_list_3
)

todo_list_4 = TodoList.create(name: 'Create TodoList model')
Item.create(
  name: 'Generate model file',
  description: 'Use the Rails generator to create a model file for the TodoList model.',
  todo_list: todo_list_4
)
Item.create(
  name: 'Define model attributes',
  description: 'Define the attributes and associations for the TodoList model in the generated file.',
  todo_list: todo_list_4
)
Item.create(
  name: 'Validate model constraints',
  description: 'Add validations to the TodoList model file to ensure data integrity.',
  todo_list: todo_list_4
)

todo_list_5 = TodoList.create(name: 'Create TodoList controller')
Item.create(
  name: 'Generate controller file',
  description: 'Use the Rails generator to create a controller file for the TodoList controller.',
  todo_list: todo_list_5
)
Item.create(
  name: 'Define controller actions',
  description: 'Define CRUD actions (create, read, update, delete) in the TodoList controller file.',
  todo_list: todo_list_5
)
Item.create(
  name: 'Setup routes',
  description: 'Configure routes.rb to map HTTP requests to the appropriate actions in the TodoList controller.',
  todo_list: todo_list_5
)
