using System;
using System.Collections.Generic;
using System.Threading;
using System.Threading.Tasks;

namespace Valeant.Sp.UprsWeb.Helpers {
    public class TaskQueue<T> : IDisposable  {
        private readonly object _locker = new object();
        private readonly Thread[] _workers;
        private readonly Queue<T> _taskQ = new Queue<T>();

        public TaskQueue(int workerCount, Task<T> task) {
            _workers = new Thread[workerCount];
            for (var i = 0; i < workerCount; i++) (_workers[i] = new Thread(Consume)).Start();
        }

        public void Dispose() {
            foreach (var worker in _workers) EnqueueTask(default(T));
            foreach (var worker in _workers) worker.Join();
        }

        public void EnqueueTask(T data) {
            lock (_locker) {
                _taskQ.Enqueue(data);
                Monitor.PulseAll(_locker);
            }
        }

        void Consume() {
            while (true) {
                T dataTask;
                lock (_locker) {
                    while (_taskQ.Count == 0) Monitor.Wait(_locker);
                    dataTask = _taskQ.Dequeue();
                }
                if (dataTask == null) return;
                
            }
        }
    }
}