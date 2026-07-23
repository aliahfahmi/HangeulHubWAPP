using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web.Script.Serialization;

namespace HangeulHubWAPP.Instructor
{
    // One AI-drafted question, ready to be reviewed/edited/saved like any other question.
    public class GeneratedQuestion
    {
        public string QuestionText { get; set; }
        public string CorrectAnswer { get; set; }
    }

    // Handles ONE job: send a topic to the OpenAI API and get back a list of
    // quiz questions for it. Nothing here touches the database - that stays
    // in ManageQuestions.aspx.cs, same as every other question insert.
    public static class AiQuestionHelper
    {
        // Reused across calls instead of "new HttpClient()" every time - this is
        // the recommended pattern, creating a fresh one per call can exhaust
        // network sockets under load.
        private static readonly HttpClient client = new HttpClient();

        public static List<GeneratedQuestion> GenerateQuestions(string topic, string difficulty, int count)
        {
            // The API key lives in Web.config, never hardcoded in source:
            // <appSettings><add key="OpenAI_ApiKey" value="sk-..." /></appSettings>
            string apiKey = ConfigurationManager.AppSettings["OpenAI_ApiKey"];

            // We tell the AI exactly what shape of answer we want (a JSON array)
            // so the C# side can parse it without guessing.
            string prompt =
                $"Create {count} short quiz questions for {difficulty}-level Korean language students " +
                $"about the topic: \"{topic}\". " +
                "Reply with ONLY a JSON array and nothing else, in this exact format: " +
                "[{\"questionText\": \"...\", \"correctAnswer\": \"...\"}]";

            var requestBody = new
            {
                model = "gpt-4o-mini",
                messages = new[] { new { role = "user", content = prompt } }
            };

            var serializer = new JavaScriptSerializer();
            string requestJson = serializer.Serialize(requestBody);

            var request = new HttpRequestMessage(HttpMethod.Post, "https://api.openai.com/v1/chat/completions");
            request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", apiKey);
            request.Content = new StringContent(requestJson, Encoding.UTF8, "application/json");

            // Kept synchronous (.Result) on purpose - the rest of the project's
            // ADO.NET calls are synchronous too, so this matches that style and
            // avoids needing Async="true" on every page that uses it.
            HttpResponseMessage response = client.SendAsync(request).Result;
            string responseJson = response.Content.ReadAsStringAsync().Result;

            if (!response.IsSuccessStatusCode)
            {
                throw new Exception("AI request failed: " + responseJson);
            }

            string aiReplyText = ExtractReplyText(responseJson, serializer);
            return ParseQuestions(aiReplyText, serializer);
        }

        // OpenAI wraps the actual reply inside: { choices: [ { message: { content: "..." } } ] }
        // This digs through that wrapper to get just the text the AI wrote.
        private static string ExtractReplyText(string responseJson, JavaScriptSerializer serializer)
        {
            var responseDict = (Dictionary<string, object>)serializer.DeserializeObject(responseJson);
            var choices = (object[])responseDict["choices"];
            var firstChoice = (Dictionary<string, object>)choices[0];
            var message = (Dictionary<string, object>)firstChoice["message"];
            return (string)message["content"];
        }

        // The AI's reply text IS a JSON array (per our prompt), so parse it the
        // same way and turn it into a plain C# list.
        private static List<GeneratedQuestion> ParseQuestions(string aiReplyText, JavaScriptSerializer serializer)
        {
            // Sometimes models wrap their JSON in ```json ... ``` - strip that off if present.
            string cleaned = aiReplyText.Trim();
            if (cleaned.StartsWith("```"))
            {
                cleaned = cleaned.Trim('`');
                cleaned = cleaned.Replace("json", "").Trim();
            }

            var rawQuestions = (object[])serializer.DeserializeObject(cleaned);
            var results = new List<GeneratedQuestion>();

            foreach (Dictionary<string, object> q in rawQuestions)
            {
                results.Add(new GeneratedQuestion
                {
                    QuestionText = q["questionText"].ToString(),
                    CorrectAnswer = q["correctAnswer"].ToString()
                });
            }

            return results;
        }
    }
}