import React, { createContext, useContext, useEffect, useState } from 'react';
import {
  getColorsScheme,
  getCurrentLanguage,
  getSessionActivityStatus,
  initialize,
  setColorsScheme,
  setCurrentLanguage,
  LanguageType,
  setSignatureIntroImage,
} from '@aag-development/react-native-metaone-wallet-sdk';
import sdkConfig from '../sdkConfig.json';
import { version } from '../../package.json';
import type { ColorsScheme } from '@aag-development/react-native-metaone-wallet-sdk';
import { Image, Platform } from 'react-native';

interface IAppData {
  isInitialized: boolean;
  isAuthorized: boolean;
  colors?: ColorsScheme;
  language?: string;
  setIsAuthorized: (isAuthorized: boolean) => void;
  isGlobalLoading: boolean;
  setGlobalLoading: (isAuthorized: boolean) => void;
  onChangeTheme: (theme: string) => void;
  onChangeLanguage: (lang: LanguageType) => void;
}

const AppContext = createContext<IAppData>({
  isInitialized: false,
  isAuthorized: false,
  colors: undefined,
  language: undefined,
  setIsAuthorized: () => undefined,
  isGlobalLoading: false,
  setGlobalLoading: () => undefined,
  onChangeTheme: (theme: string) => theme,
  onChangeLanguage: (lang: LanguageType) => lang,
});

export const useAppContext = () => {
  return useContext(AppContext);
};

interface IAppProviderProps {
  children: React.ReactNode;
}

const useApp = () => {
  const [isInitialized, setIsInitialized] = useState(false);
  const [isAuthorized, setIsAuthorized] = useState(false);
  const [isGlobalLoading, setGlobalLoading] = useState(false);
  const [colors, setColors] = useState<ColorsScheme>();
  const [language, setLanguage] = useState<string>();

  const fetchColorsScheme = async () => {
    const colorsScheme = await getColorsScheme();
    setColors(colorsScheme);
  };

  const fetchCurrentLanguage = async () => {
    const locale = await getCurrentLanguage();
    setLanguage(locale);
  };

  useEffect(() => {
    const initializeSDK = async () => {
      await initialize({
        sdkEnvironment: sdkConfig.environment,
        sdkKey: Platform.OS === 'ios' ? sdkConfig.iOSKey : sdkConfig.androidKey,
        sdkConfigUrl: sdkConfig.configUrl,
        sdkApiClientReference: sdkConfig.apiClientReference,
        sdkApiKeyPhrase: sdkConfig.apiKeyPhrase,
        version,
        sdkRealm: sdkConfig.realm,
      });
      setSignatureIntroImage(Image.resolveAssetSource(require("../assets/signature_intro.png")).uri)
      await fetchColorsScheme();
      await fetchCurrentLanguage();
      const activityStatus = await getSessionActivityStatus();
      if (activityStatus === 'ACTIVE') {
        setIsAuthorized(true);
      }
      setGlobalLoading(false);
      setIsInitialized(true);
    };
    initializeSDK();
  }, []);

  const onChangeTheme = (theme: string) => {
    setColorsScheme(theme === 'dark' ? darkTheme : lightTheme);
    fetchColorsScheme();
  };

  const onChangeLanguage = (locale: LanguageType) => {
    setCurrentLanguage(locale);
    fetchCurrentLanguage();
  };

  return {
    colors,
    language,
    isInitialized,
    isAuthorized,
    setIsAuthorized,
    isGlobalLoading,
    setGlobalLoading,
    onChangeTheme,
    onChangeLanguage,
  };
};

export const AppProvider: React.FC<IAppProviderProps> = ({ children }) => {
  const value = useApp();
  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
};

const lightTheme = {
  alwaysWhite: '#FFFFFF',
  alwaysBlack: '#101111',
  primary: '#386CF3',
  primary80: '#386CF3CC',
  primary60: '#386CF399',
  primary40: '#386CF366',
  primary20: '#417FF6CC',
  secondary: '#604EFF',
  secondary80: '#604EFFCC',
  secondary60: '#604EFF99',
  secondary40: '#604EFF66',
  secondary20: '#604EFF33',
  secondary15: '#604EFF26',
  primaryButtonBg: '#386CF3',
  primaryButtonBgDisabled: '#386CF360',
  primaryButtonText: '#FFFFFF',
  secondaryButtonBg: '#417FF6CC',
  secondaryButtonBgDisabled: '#417FF633',
  secondaryButtonText: '#386CF3',
  errorButtonBg: '#FFFFFF',
  errorButtonText: '#D93F33',
  green: '#1BAC3F',
  greenBg: '#B7E8C3',
  yellow: '#DEA511',
  yellowBg: '#F0E29A',
  yellow15: '#DEA51126',
  red: '#D93F33',
  redBg: '#F5B9B5',
  blue: '#386CF3',
  blueBg: '#C6DAFF',
  wireframes: '#BDC2CA',
  wireframesLight: '#D8E0E5',
  gradientLight: '#E0F9FD',
  gradientViolet: '#6851F5',
  gradientBlue: '#7999FE',
  average: '#F7931A',
  background: '#F0F2F4',
  background20: '#F0F2F433',
  white: '#FFFFFF',
  white20: '#FFFFFF33',
  white50: '#FFFFFF80',
  white80: '#FFFFFFCC',
  black: '#101111',
  black80: '#101111CC',
  black60: '#10111199',
  black40: '#10111166',
  black20: '#10111133',
  black15: '#10111126',
  black10: '#1011111A',
  black5: '#1011110D',
  pin: '#0066FF',
};

const darkTheme = {
  alwaysWhite: '#FFFFFF',
  alwaysBlack: '#101111',
  primary: '#00D2B4',
  primary80: '#00D2B4CC',
  primary60: '#00D2B499',
  primary40: '#00D2B466',
  primary20: '#00D2B433',
  secondary: '#00D2B4',
  secondary80: '#00D2B4CC',
  secondary60: '#00D2B499',
  secondary40: '#00D2B466',
  secondary20: '#00D2B433',
  secondary15: '#00D2B426',
  primaryButtonBg: '#00D2B4',
  primaryButtonBgDisabled: '#00D2B466',
  primaryButtonText: '#1E2832',
  secondaryButtonBg: '#00D2B466',
  secondaryButtonBgDisabled: '#00D2B41A',
  secondaryButtonText: '#00D2B4',
  errorButtonBg: '#EF4444',
  errorButtonText: '#FFFFFF',
  green: '#1BAC3F',
  greenBg: '#B7E8C3',
  yellow: '#DEA511',
  yellowBg: '#F0E29A',
  yellow15: '#DEA51126',
  red: '#D93F33',
  redBg: '#F5B9B5',
  blue: '#386CF3',
  blueBg: '#C6DAFF',
  wireframes: '#BDC2CA',
  wireframesLight: '#D8E0E5',
  gradientLight: '#89EBDF',
  gradientViolet: '#00D2B4',
  gradientBlue: '#00C3A8',
  average: '#F7931A',
  background: '#080E0E',
  background20: '#080E0E33',
  white: '#34353B',
  white20: '#34353B33',
  white50: '#34353B80',
  white80: '#34353BCC',
  black: '#FFFFFF',
  black80: '#FFFFFFCC',
  black60: '#FFFFFF99',
  black40: '#FFFFFF66',
  black20: '#FFFFFF33',
  black15: '#FFFFFF26',
  black10: '#FFFFFF1A',
  black5: '#FFFFFF0D',
  pin: '#00D2B4',
};
