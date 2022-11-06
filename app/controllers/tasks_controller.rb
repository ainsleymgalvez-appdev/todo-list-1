class TasksController < ApplicationController
  
  
  def index
    matching_tasks = Task.all

    @list_of_tasks = matching_tasks.where({:user_id => session.fetch(:user_id)}).order({ :created_at => :desc })

    render({ :template => "tasks/index.html.erb" })
  end

  def show
    the_id = params.fetch("path_id")

    matching_tasks = Task.where({ :id => the_id })

    @the_task = matching_tasks.at(0)

    render({ :template => "tasks/show.html.erb" })
  end

  def create
    the_task = Task.new
    the_task.task = params.fetch("query_task")
    the_task.user_id = session.fetch(:user_id)

    if the_task.valid?

      the_task.status = "next_up"

      the_task.save
      redirect_to("/", { :notice => "Task created successfully." })
    else
      redirect_to("/", { :alert => the_task.errors.full_messages.to_sentence })
    end
  end

  def update
    the_id = params.fetch("path_id")
    the_task = Task.where({ :id => the_id }).at(0)
    the_task.user_id = session.fetch(:user_id)
    the_task.status = params.fetch("query_status")

    if the_task.valid?

      the_task.save

      redirect_to("/", { :notice => "Task updated successfully."} )
    else
      redirect_to("/", { :alert => the_task.errors.full_messages.to_sentence })
    end
  end

  def destroy
    the_id = params.fetch("path_id")
    the_task = Task.where({ :id => the_id }).at(0)

    the_task.destroy

    redirect_to("/tasks", { :notice => "Task deleted successfully."} )
  end
end
