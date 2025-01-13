using KnapSackProblem;

public class KnapsackBatchProcessor
{
    private readonly int _orderThreshold;

    public KnapsackBatchProcessor(int orderThreshold)
    {
        _orderThreshold = orderThreshold;
    }

    public List<List<Account>> CreateBatches(List<Account> accounts)
    {
        var batches = new List<List<Account>>();

        while (accounts.Count > 0)
        {
            var currentBatch = new List<Account>();
            var currentBatchOrderCount = 0;

            var dp = new int[accounts.Count + 1, _orderThreshold + 1];
            var includedAccounts = new bool[accounts.Count];

            for (int i = 1; i <= accounts.Count; i++)
            {
                for (int j = 1; j <= _orderThreshold; j++)
                {
                    if (accounts[i - 1].OrderCount > j)
                    {
                        dp[i, j] = dp[i - 1, j];
                    }
                    else
                    {
                        dp[i, j] = Math.Max(dp[i - 1, j], dp[i - 1, j - accounts[i - 1].OrderCount] + accounts[i - 1].OrderCount);
                    }
                }
            }

            int iIndex = accounts.Count, jIndex = _orderThreshold;
            while (iIndex > 0 && jIndex > 0)
            {
                if (dp[iIndex, jIndex] != dp[iIndex - 1, jIndex])
                {
                    includedAccounts[iIndex - 1] = true;
                    jIndex -= accounts[iIndex - 1].OrderCount;
                }
                iIndex--;
            }

            for (int k = 0; k < accounts.Count; k++)
            {
                if (includedAccounts[k])
                {
                    currentBatch.Add(accounts[k]);
                }
            }

            accounts = accounts.Where((account, index) => !includedAccounts[index]).ToList();

            batches.Add(currentBatch);
        }

        return batches;
    }

    public List<List<Account>> CreateBatches2(List<Account> accounts)
    {
        var batches = new List<List<Account>>();
        var currentBatch = new List<Account>();
        var currentBatchOrderCount = 0;

        foreach (var account in accounts)
        {
            if (currentBatchOrderCount + account.OrderCount > _orderThreshold)
            {
                batches.Add(currentBatch);
                currentBatch = new List<Account> { account };
                currentBatchOrderCount = account.OrderCount;
            }
            else
            {
                currentBatch.Add(account);
                currentBatchOrderCount += account.OrderCount;
            }
        }

        if (currentBatch.Count > 0)
        {
            batches.Add(currentBatch);
        }

        return batches;
    }
}