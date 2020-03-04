import Foundation

class NetworkManager
{
    static let shared = NetworkManager()
    let baseURL = "https://api.github.com/users/"
    let errorMessage = "Something happened"

    private init() {}

    func getFollowers(for username: String, page: Int, completed: @escaping ([Follower]?, String?) -> Void)
    {
        let endpoint = baseURL + "\(username)/followers?per_page=100&page=\(page)"
        guard let url = URL(string: endpoint) else
        {
            completed(nil, self.errorMessage)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let _ = error
            {
                completed(nil, self.errorMessage)
                return
            }

            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else
            {
                completed(nil, self.errorMessage)
                return
            }

            guard let data = data else
            {
                completed(nil, self.errorMessage)
                return
            }

            do
            {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([Follower].self, from: data)

                completed(followers, nil)
            }
            catch { completed(nil, self.errorMessage) }
        }

        task.resume()
    }
}
