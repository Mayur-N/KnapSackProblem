using KnapSackProblem;

var accounts = new List<Account>
        {
            new Account { Id = 1, OrderCount = 1000 },
            new Account { Id = 2, OrderCount = 2000 },
            new Account { Id = 3, OrderCount = 1500 },
            new Account { Id = 4, OrderCount = 500 },
            new Account { Id = 5, OrderCount = 3000 },
            new Account { Id = 6, OrderCount = 800 },
            new Account { Id = 7, OrderCount = 1200 },
            new Account { Id = 8, OrderCount = 2500 },
            new Account { Id = 9, OrderCount = 1800 },
            new Account { Id = 10, OrderCount = 400 },

            new Account { Id = 11, OrderCount = 1205 },
            new Account { Id = 12, OrderCount = 2507 },
            new Account { Id = 13, OrderCount = 1809 },
            new Account { Id = 14, OrderCount = 411 },
        };

var batchProcessor = new KnapsackBatchProcessor(4500);
var batches = batchProcessor.CreateBatches(accounts);

Console.WriteLine("Knapsack Algorithm");
foreach (var batch in batches)
{
    Console.WriteLine("Batch:");
    foreach (var account in batch)
    {
        Console.WriteLine($"Account {account.Id} - Order Count: {account.OrderCount}");
    }
    Console.WriteLine();
}


Console.WriteLine("Greedy Algorithm");
batches = batchProcessor.CreateBatches2(accounts);

foreach (var batch in batches)
{
    Console.WriteLine("Batch:");
    foreach (var account in batch)
    {
        Console.WriteLine($"Account {account.Id} - Order Count: {account.OrderCount}");
    }
    Console.WriteLine();
}