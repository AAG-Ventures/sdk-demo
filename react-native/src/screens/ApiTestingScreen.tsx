import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';
import {
  getWallets,
  addUserContact,
  updateUserContact,
  deleteUserContact,
  type ColorsScheme,
  getCurrencies,
  getNFTs,
  getTransactions,
  getUserContacts,
  ContactsApiModel,
} from '@aag-development/react-native-metaone-wallet-sdk';
import useColorsAwareObject from '../hooks/useColorsAwareObject';
import { Container } from '../components/Container';
import DropDownPicker from 'react-native-dropdown-picker';
import Input from '../components/Input';
import { useToast } from 'react-native-toast-notifications';
import CustomButton from '../components/Button/CustomButton';

const items = [
  { label: 'GetWallets', value: 'GetWallets' },
  { label: 'GetCurrencies', value: 'GetCurrencies' },
  { label: 'GetNFTs', value: 'GetNFTs' },
  { label: 'GetTransactions', value: 'GetTransactions' },
  { label: 'GetUserContacts', value: 'GetUserContacts' },
  { label: 'AddUserContact', value: 'AddUserContact' },
  { label: 'UpdateUserContact', value: 'UpdateUserContact' },
  { label: 'DeleteUserContact', value: 'DeleteUserContact' },
];

const ID_VALUES = ["UpdateUserContact", "DeleteUserContact"]
const BODY_VALUES = ["AddUserContact", "UpdateUserContact"]

const ApiTestingScreen: React.FC = () => {
  const styles = useColorsAwareObject(screenStyles);
  const toast = useToast();
  const [value, setValue] = React.useState<string | null>(null);
  const [visible, setVisible] = React.useState<boolean>(false);
  const [requestText, setRequestText] = React.useState<string>();
  const [responseText, setResponseText] = React.useState<string>();

  const [contactId, setContactId] = React.useState<string | null>(null);
  const [visibleIdPicker, setVisibleIdPicker] = React.useState<boolean>(false);

  const [contactIds, setContactIds] = React.useState<{ label: string, value: string }[]>([]);
  const [contacts, setContacts] = React.useState<ContactsApiModel.Contact[]>([]);

  const onSelectApi = ({ value: changed }: any) => {
    if (changed !== value) {
      setResponseText(undefined);
      if (ID_VALUES.includes(changed)) {
        getUserContacts().then(response => {
          setContacts(response.data.contacts)
          setContactIds(response.data.contacts.map(i => ({ label: `${i.name} (${i?.id})`, value: String(i?.id) })))
        })
        setRequestText(undefined);
      } else if (changed === "AddUserContact") {
        setRequestText(`{
          "data": {
              "name": "Meliana5",
              "wallets": [
                  {
                      "name": "Meliana's ETH wallet34",
                      "address": "0xc4827dad05333279874cd7d2c76f49b63ccb79033455"
                  },
                  {
                      "name": "Meliana's ETH wallet23",
                      "address": "0xc4827dad05333279874cd7d2c76f49b63ccb790323455"
                  }
              ]
          }
        }`)
      }
    }
  };

  const onSelectContact = ({ value: changed }: any) => {
    if (changed !== contactId) {
      if (value === "UpdateUserContact") {
        const contact = contacts.find(i => i.id === changed)
        if (contact) {
          setRequestText(`{
            "data": ${JSON.stringify(contact)}
          }`)
        }
      }
    }
  };

  const [loading, setLoading] = React.useState(false)
  const onSubmit = async () => {
    setLoading(true)
    try {
      let response: any;
      if (value === 'GetWallets') {
        response = await getWallets();
      } else if (value === 'GetCurrencies') {
        response = await getCurrencies();
      } else if (value === 'GetNFTs') {
        response = await getNFTs();
        console.log('getNFTs', response);
      } else if (value === 'GetTransactions') {
        response = await getTransactions(
          undefined,
          undefined,
          undefined,
          undefined,
          20,
          0,
        );
      } else if (value === 'GetUserContacts') {
        response = await getUserContacts();
      } else if (value === 'AddUserContact') {
        response = await addUserContact(JSON.parse(requestText!));
      } else if (value === 'UpdateUserContact') {
        if (!contactId) return toast.show('Please choose a contact id', { type: 'warning' });
        response = await updateUserContact(contactId, JSON.parse(requestText!));
      } else if (value === 'DeleteUserContact') {
        if (!contactId) return toast.show('Please choose a contact id', { type: 'warning' });
        response = await deleteUserContact(contactId);
      }
      setResponseText(response ? JSON.stringify(response) : undefined);
      setLoading(false)
    } catch (error) {
      setLoading(false)
      console.log("ERROR", error)
    }
  };
  return (
    <Container>
      <View style={styles.head}>
        <Text style={styles.label}>APIs</Text>
      </View>
      <View style={styles.wrapper}>
        <DropDownPicker
          open={visible}
          setOpen={setVisible}
          value={value}
          setValue={setValue}
          items={items}
          placeholder={'Choose an API'}
          onSelectItem={onSelectApi}
          style={visible && styles.dropdown}
        />
        <CustomButton
          onPress={onSubmit}
          disabled={!value}
          label='SUBMIT'
          loading={loading}
        />
        {
          value && ID_VALUES.includes(value) &&
          <DropDownPicker
            open={visibleIdPicker}
            setOpen={setVisibleIdPicker}
            value={contactId}
            setValue={setContactId}
            items={contactIds}
            placeholder={'Choose a contact id'}
            onSelectItem={onSelectContact}
          />
        }
        {
          value && BODY_VALUES.includes(value) &&
          <Input
            style={styles.input}
            placeholder="Request Body"
            multiline
            value={requestText}
            onChangeText={setRequestText}
          />
        }
        <Input
          style={styles.input}
          placeholder="Response"
          multiline
          value={responseText}
        />
      </View>
    </Container>
  );
};

const screenStyles = (colors: ColorsScheme) =>
  StyleSheet.create({
    label: {
      fontSize: 20,
      fontWeight: '700',
      color: colors.black,
      textAlign: 'center',
    },
    text: {
      color: colors.black,
    },
    head: {
      width: '100%',
      paddingVertical: 10,
    },
    wrapper: {
      flex: 1,
      width: '100%',
      gap: 15,
      padding: 20,
    },
    input: {
      color: colors.black,
      padding: 10,
      borderWidth: 1,
      marginBottom: 20,
      borderRadius: 4,
      borderColor: colors.black60,
    },
    dropdown: {
      marginBottom: 200
    }
  });

export default ApiTestingScreen;
