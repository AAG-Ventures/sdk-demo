import {useMemo} from 'react';
import {useAppContext} from './useApp';
import type {ColorsScheme} from '@aag-development/react-native-metaone-wallet-sdk';

type AnyObject = Record<string, unknown>;
type Generator<T = AnyObject> = (colors: ColorsScheme) => T;

const useColorsAwareObject = <T = AnyObject>(fn: Generator<T>) => {
  const {colors} = useAppContext();
  return useMemo(() => {
    return fn(colors!);
  }, [fn, colors]);
};

export default useColorsAwareObject;
