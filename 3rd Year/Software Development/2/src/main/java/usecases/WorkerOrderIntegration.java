package usecases;

import javax.enterprise.inject.Model;
import javax.enterprise.inject.Specializes;
import javax.json.Json;
import javax.json.JsonObject;
import javax.json.JsonReader;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.StringReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Arrays;
import java.util.List;
import java.util.Random;

@Specializes
@Model
public class WorkerOrderIntegration extends WorkerOrder {

    @Override
    public void retrieveTask() {
        try {
            System.out.println("SPECIAL RETRIVE");
            URL url = new URL("http://localhost:8005/tasks");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();

            connection.setRequestMethod("GET");

            int responseCode = connection.getResponseCode();

            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));
            StringBuilder responseBody = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                responseBody.append(line);
            }
            reader.close();

            System.out.println(responseBody.toString());

            JsonReader jsonReader = Json.createReader(new StringReader(responseBody.toString()));
            JsonObject jsonObject = jsonReader.readObject();

            String title = jsonObject.getString("task");
            String type = jsonObject.getString("task_type");

            this.getCreatedOrder().setWorkTitle(title);
            this.getCreatedOrder().setWorkType(type);
            this.getCreatedOrder().setSuccess(true);

            System.out.println(
                    String.format("SET SPECIAL. TITLE: %s | TYPE: %s", title, type)
            );

        } catch (Exception ex) {
            this.getCreatedOrder().setSuccess(false);
            System.out.println("ERROR happened " + ex.getMessage());
        }

    }
}
