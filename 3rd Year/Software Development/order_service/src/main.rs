use axum::{
    routing::{get},
    Router, Json, http::StatusCode,
};
use rand::seq::SliceRandom;
use serde::{Serialize, Deserialize};

use std::net::SocketAddr;



#[tokio::main]
async fn main() {

    let app = Router::new()
        .route("/", get(root))
        .route("/tasks", get(send_task));
    
    let addr = SocketAddr::from(([127, 0, 0, 1], 8005));
    println!("Listening on - {addr:?}");

    axum::Server::bind(&addr)
        .serve(app.into_make_service())
        .await
        .unwrap();
}

async fn root() -> &'static str {
    "Hello api"
}


#[derive(Debug, Deserialize, Serialize)]
struct Task {
    task: String,
    task_type: String,
}

async fn send_task() -> (StatusCode, Json<Task>) {

    let tasks = vec!["Programming", "QA", "Testing", "Meetings", "Repairs", "Tech Support", "Cooking", "Serving Coffee", "Brain storming"];
    let task_types = vec!["Low Priority", "Mid Priority", "High Priority", "Discussion", "Urgent", "Important"];

    let mut rng = rand::thread_rng();

    let new_task = Task {
        task: tasks.choose(&mut rng).unwrap().to_string(),
        task_type: task_types.choose(&mut rng).unwrap().to_string(),
    };

    (StatusCode::OK, Json(new_task))
}