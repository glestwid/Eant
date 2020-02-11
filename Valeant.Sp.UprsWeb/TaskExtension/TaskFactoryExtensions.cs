using System;
using System.Threading;
using System.Threading.Tasks;

namespace Valeant.Sp.UprsWeb.TaskExtension
{
    public static class TaskFactoryExtensions {
        public static Task FromAsync(this TaskFactory factory, WaitHandle waitHandle) {
            if (factory == null) throw new ArgumentNullException(nameof(factory));
            if (waitHandle == null) throw new ArgumentNullException(nameof(waitHandle));
            var tcs = new TaskCompletionSource<object>();
            var rwh = ThreadPool.RegisterWaitForSingleObject(waitHandle, delegate { tcs.TrySetResult(null); }, null, -1, true);
            var t = tcs.Task;
            t.ContinueWith(_ => rwh.Unregister(null), TaskContinuationOptions.ExecuteSynchronously);
            return t;
        }
    }
}