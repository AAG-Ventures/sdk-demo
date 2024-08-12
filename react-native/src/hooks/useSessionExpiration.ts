import {useState, useEffect} from 'react';

const useSessionExpiration = (toast: {
  show: (arg0: string, arg1: {type: string}) => void;
}) => {
  const [expireAt, setExpireAt] = useState<number | undefined>();
  const [expireAtSeconds, setExpireAtSeconds] = useState<number | undefined>();

  useEffect(() => {
    if (expireAt === undefined) {
      return;
    }
    const checkExpiration = () => {
      const currentTime = new Date().getTime() / 1000;
      const remainingTimeInSeconds = Math.floor(expireAt - currentTime);

      if (remainingTimeInSeconds <= 0) {
        toast.show('Session expired. Please refresh.', {type: 'warning'});
        setExpireAt(undefined);
      } else {
        setExpireAtSeconds(remainingTimeInSeconds);
      }
    };
    checkExpiration();
    const interval = setInterval(checkExpiration, 1000);
    return () => clearInterval(interval);
  }, [expireAt, toast, expireAtSeconds]);

  return {expireAtSeconds, setExpireAt};
};

export default useSessionExpiration;
